//
//  UITextView+ZhInputLimit.m
//  JKCategories (https://github.com/shaojiankui/JKCategories)
//
//  Created by Jakey on 2016/11/29.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//

#import "UITextView+ZhInputLimit.h"
#import <objc/runtime.h>

static const void *JKTextViewInputLimitMaxLength = &JKTextViewInputLimitMaxLength;

@implementation UITextView (ZhInputLimit)
- (NSInteger)zh_maxLength {
    return [objc_getAssociatedObject(self, JKTextViewInputLimitMaxLength) integerValue];
}
- (void)setzh_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, JKTextViewInputLimitMaxLength, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zh_textViewTextDidChange:)
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
+ (void)load {
//    [super load];
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(zh_textView_limit_swizzledDealloc));
    method_exchangeImplementations(origMethod, newMethod);
}
- (void)zh_textView_limit_swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zh_textView_limit_swizzledDealloc];
}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end
