//
//  UITextView+Zh.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/3/1.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UITextView+ZhInputLimit.h"
#import <objc/runtime.h>

static const void *JKTextViewInputLimitMaxLength = &JKTextViewInputLimitMaxLength;
// 占位文字
static const void *PlaceholderViewKey = &PlaceholderViewKey;
// 占位文字颜色
static const void *PlaceholderColorKey = &PlaceholderColorKey;
// 最大高度
static const void *TextViewMaxHeightKey = &TextViewMaxHeightKey;
// 最小高度
static const void *TextViewMinHeightKey = &TextViewMinHeightKey;
// 高度变化的block
static const void *TextViewHeightDidChangedBlockKey = &TextViewHeightDidChangedBlockKey;
// 存储添加的图片
static const void *TextViewImageArrayKey = &TextViewImageArrayKey;
// 存储最后一次改变高度后的值
static const void *TextViewLastHeightKey = &TextViewLastHeightKey;


@interface UITextView ()
// 存储添加的图片
@property (nonatomic, strong) NSMutableArray *imageArray;
// 存储最后一次改变高度后的值
@property (nonatomic, assign) CGFloat lastHeight;

@end

@implementation UITextView (ZhInputLimit)

#pragma mark - Swizzle Dealloc

+ (void)load {
    // 交换dealoc
    Method dealoc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
    Method myDealloc = class_getInstanceMethod(self.class, @selector(myDealloc));
    method_exchangeImplementations(dealoc, myDealloc);
}

- (void)myDealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UITextView *placeholderView = objc_getAssociatedObject(self, PlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        for (NSString *property in propertys) {
            @try {
                [self removeObserver:self forKeyPath:property];
            } @catch (NSException *exception) {}
        }
    }
    [self myDealloc];
}

- (NSInteger)zh_maxLength {
    return [objc_getAssociatedObject(self, JKTextViewInputLimitMaxLength) integerValue];
}
- (void)setzh_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, JKTextViewInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zh_textViewTextDidChange:)
                                                name:@"UITextViewTextDidChangeNotification" object:self];

}
- (void)zh_textViewTextDidChange:(NSNotification *)notification {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.zh_maxLength > 0 && toBeString.length > self.zh_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.zh_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.zh_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.zh_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.zh_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}

#pragma mark - set && get
- (UITextView *)placeholderView {
    
    // 为了让占位文字和textView的实际文字位置能够完全一致，这里用UITextView
    UITextView *placeholderView = objc_getAssociatedObject(self, PlaceholderViewKey);
    
    if (!placeholderView) {
        
        // 初始化数组
        self.imageArray = [NSMutableArray array];
        
        placeholderView = [[UITextView alloc] init];
        // 动态添加属性的本质是: 让对象的某个属性与值产生关联
        objc_setAssociatedObject(self, PlaceholderViewKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        placeholderView = placeholderView;
        
        // 设置基本属性
        placeholderView.scrollEnabled = placeholderView.userInteractionEnabled = NO;
        //        self.scrollEnabled = placeholderView.scrollEnabled = placeholderView.showsHorizontalScrollIndicator = placeholderView.showsVerticalScrollIndicator = placeholderView.userInteractionEnabled = NO;
        placeholderView.textColor = [UIColor lightGrayColor];
        placeholderView.backgroundColor = [UIColor clearColor];
        [self refreshPlaceholderView];
        [self addSubview:placeholderView];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
        
        // 这些属性改变时，都要作出一定的改变，尽管已经监听了TextDidChange的通知，也要监听text属性，因为通知监听不到setText：
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        
        // 监听属性
        for (NSString *property in propertys) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
        
    }
    return placeholderView;
}

- (void)setZh_placeholder:(NSString *)zh_placeholder{
    // 为placeholder赋值
    [self placeholderView].text = zh_placeholder;
}
- (NSString *)zh_placeholder{
    // 如果有placeholder值才去调用，这步很重要
    if (self.placeholderExist) {
        return [self placeholderView].text;
    }
    return nil;
}
- (void)setZh_placeholderColor:(UIColor *)zh_placeholderColor{
    // 如果有placeholder值才去调用，这步很重要
    if (!self.placeholderExist) {
        NSLog(@"请先设置placeholder值！");
    } else {
        self.placeholderView.textColor = zh_placeholderColor;
        
        // 动态添加属性的本质是: 让对象的某个属性与值产生关联
        objc_setAssociatedObject(self, PlaceholderColorKey, zh_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
-(UIColor *)zh_placeholderColor{
    return objc_getAssociatedObject(self, PlaceholderColorKey);
}
- (void)setZh_maxHeight:(CGFloat)zh_maxHeight{
    CGFloat max = zh_maxHeight;
    
    // 如果传入的最大高度小于textView本身的高度，则让最大高度等于本身高度
    if (zh_maxHeight < self.frame.size.height) {
        max = self.frame.size.height;
    }
    
    objc_setAssociatedObject(self, TextViewMaxHeightKey, [NSString stringWithFormat:@"%lf", max], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CGFloat)zh_maxHeight{
    return [objc_getAssociatedObject(self, TextViewMaxHeightKey) doubleValue];
}
- (void)setZh_minHeight:(CGFloat)zh_minHeight{
    objc_setAssociatedObject(self, TextViewMinHeightKey, [NSString stringWithFormat:@"%lf", zh_minHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (CGFloat)zh_minHeight{
    return [objc_getAssociatedObject(self, TextViewMinHeightKey) doubleValue];
}
- (void)setZh_textViewHeightDidChanged:(textViewHeightDidChangedBlock)zh_textViewHeightDidChanged{
    objc_setAssociatedObject(self, TextViewHeightDidChangedBlockKey, zh_textViewHeightDidChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(textViewHeightDidChangedBlock)zh_textViewHeightDidChanged{
    void(^textViewHeightDidChanged)(CGFloat currentHeight) = objc_getAssociatedObject(self, TextViewHeightDidChangedBlockKey);
    return textViewHeightDidChanged;
}
-(NSArray *)zh_getImages{
    return self.imageArray;
}
- (void)zh_LineSpace:(CGFloat)lineSpace{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText?:[[NSAttributedString alloc] initWithString:self.text]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace < 0 ? 0 : lineSpace];
    paragraphStyle.alignment = self.textAlignment;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attStr;
}

- (void)setLastHeight:(CGFloat)lastHeight {
    objc_setAssociatedObject(self, TextViewLastHeightKey, [NSString stringWithFormat:@"%lf", lastHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)lastHeight {
    return [objc_getAssociatedObject(self, TextViewLastHeightKey) doubleValue];
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    objc_setAssociatedObject(self, TextViewImageArrayKey, imageArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)imageArray {
    return objc_getAssociatedObject(self, TextViewImageArrayKey);
}
-(void)zh_autoHeightWithMaxHeight:(CGFloat)maxHeight{
    [self zh_autoHeightWithMaxHeight:maxHeight textViewHeightDidChanged:nil];
}
// 是否启用自动高度，默认为NO
static bool autoHeight = NO;
-(void)zh_autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged{
    autoHeight = YES;
    [self placeholderView];
    self.zh_maxHeight = maxHeight;
    if (textViewHeightDidChanged) self.zh_textViewHeightDidChanged = textViewHeightDidChanged;
}

#pragma mark - addImage
/* 添加一张图片 */
- (void)zh_addImage:(UIImage *)image
{
    [self zh_addImage:image size:CGSizeZero];
}

/* 添加一张图片 image:要添加的图片 size:图片大小 */
- (void)zh_addImage:(UIImage *)image size:(CGSize)size
{
    [self zh_insertImage:image size:size index:self.attributedText.length > 0 ? self.attributedText.length : 0];
}

/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 */
- (void)zh_insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index
{
    [self zh_addImage:image size:size index:index multiple:-1];
}

/* 添加一张图片 image:要添加的图片 multiple:放大／缩小的倍数 */
- (void)zh_addImage:(UIImage *)image multiple:(CGFloat)multiple
{
    [self zh_addImage:image size:CGSizeZero index:self.attributedText.length > 0 ? self.attributedText.length : 0 multiple:multiple];
}

/* 插入一张图片 image:要添加的图片 multiple:放大／缩小的倍数 index:插入的位置 */
- (void)zh_insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index
{
    [self zh_addImage:image size:CGSizeZero index:index multiple:multiple];
}

/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 multiple:放大／缩小的倍数 */
- (void)zh_addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index multiple:(CGFloat)multiple {
    if (image) [self.imageArray addObject:image];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    CGRect bounds = textAttachment.bounds;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        bounds.size = size;
        textAttachment.bounds = bounds;
    } else if (multiple <= 0) {
        CGFloat oldWidth = textAttachment.image.size.width;
        CGFloat scaleFactor = oldWidth / (self.frame.size.width - 10);
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    } else {
        bounds.size = image.size;
        textAttachment.bounds = bounds;
    }
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:NSMakeRange(index, 0) withAttributedString:attrStringWithImage];
    self.attributedText = attributedString;
    [self textViewTextChange];
    [self refreshPlaceholderView];
}


#pragma mark - KVO监听属性改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshPlaceholderView];
    if ([keyPath isEqualToString:@"text"]) [self textViewTextChange];
}

// 刷新PlaceholderView
- (void)refreshPlaceholderView {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, PlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        self.placeholderView.frame = self.bounds;
        if (self.zh_maxHeight < self.bounds.size.height) self.zh_maxHeight = self.bounds.size.height;
        self.placeholderView.font = self.font;
        self.placeholderView.textAlignment = self.textAlignment;
        self.placeholderView.textContainerInset = self.textContainerInset;
        self.placeholderView.hidden = (self.text.length > 0 && self.text);
    }
}

// 处理文字改变
- (void)textViewTextChange {
    UITextView *placeholderView = objc_getAssociatedObject(self, PlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        self.placeholderView.hidden = (self.text.length > 0 && self.text);
    }
    // 如果没有启用自动高度，不执行以下方法
    if (!autoHeight) return;
    if (self.zh_maxHeight >= self.bounds.size.height) {
        
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        
        // 如果高度有变化，调用block
        if (currentHeight != self.lastHeight) {
            // 是否可以滚动
            self.scrollEnabled = currentHeight >= self.zh_maxHeight;
            CGFloat currentTextViewHeight = currentHeight >= self.zh_maxHeight ? self.zh_maxHeight : currentHeight;
            // 改变textView的高度
            if (currentTextViewHeight >= self.zh_minHeight) {
                CGRect frame = self.frame;
                frame.size.height = currentTextViewHeight;
                self.frame = frame;
                // 调用block
                if (self.zh_textViewHeightDidChanged) self.zh_textViewHeightDidChanged(currentTextViewHeight);
                // 记录当前高度
                self.lastHeight = currentTextViewHeight;
            }
        }
    }
    
    if (!self.isFirstResponder) [self becomeFirstResponder];
}

// 判断是否有placeholder值，这步很重要
- (BOOL)placeholderExist {
    
    // 获取对应属性的值
    UITextView *placeholderView = objc_getAssociatedObject(self, PlaceholderViewKey);
    
    // 如果有placeholder值
    if (placeholderView) return YES;
    
    return NO;
}




@end
