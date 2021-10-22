//
//  UIView+ZhExt.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import "UIView+ZhExt.h"
#import <objc/runtime.h>
#import <Masonry.h>
#import "UIView+HJViewStyle.h"

static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;

@implementation UIView (ZhExt)

@dynamic zh_CornerRadius,zh_Circle,maxX,maxY;

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = x;
    self.frame = tempFrame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = y;
    self.frame = tempFrame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = width;
    self.frame = tempFrame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = height;
    self.frame = tempFrame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint tempCenter =  self.center;
    tempCenter.x = centerX;
    self.center = tempCenter;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint tempCenter =  self.center;
    tempCenter.y = centerY;
    self.center = tempCenter;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}


- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect tempFrame = self.frame;
    tempFrame.size = size;
    self.frame = tempFrame;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)maxX{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)maxY{
    return self.frame.origin.y + self.frame.size.height;
}

/// 自定义方法圆角
- (void)setZh_CornerRadius:(CGFloat)zh_CornerRadius{
    self.cornerRadius = zh_CornerRadius;
}
/// 自定义方法切为圆形
- (void)setZh_Circle:(BOOL)zh_Circle{
    self.circle = zh_Circle;
}
/// 自定义边框颜色
- (void)zh_setBorderCorlor:(UIColor *)borderCorlor borderWidth:(CGFloat)width{
    self.borderWidth = width;
    self.borderColor = borderCorlor;
}

/// 自定义设置阴影效果
- (void)zh_setShadowColorWith:(UIColor *)color offSet:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius{
    self.shadowColor = color;
    self.shadowOffset = offset;
    self.shadowOpacity = opacity;
    self.shadowRadius = radius;
}
/// 设置阴影效果
- (void)zh_setShadowColor{
    self.shadowColor = [UIColor colorWithRed:42/255.0 green:45/255.0 blue:69/255.0 alpha:0.09];
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowOpacity = 1;
    self.shadowRadius = 5;
}

/// 取消阴影效果
- (void)zh_setCancelShadowColor{
    self.shadowColor = [UIColor clearColor];
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowOpacity = 0;
    self.shadowRadius = 0;
}

/// 隐藏视图 是否存在动画效果
- (void)hiddenWithAnimation:(BOOL)HasAnimation{
    if (HasAnimation) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [self.layer addAnimation:animation forKey:nil];
        
        self.hidden = YES;
    }else{
        self.hidden = YES;
    }
}

/// 显示视图 是否存在动画效果
- (void)showWithAnimation:(BOOL)HasAnimation{
    if (HasAnimation) {
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 0.4;
        [self.layer addAnimation:animation forKey:nil];
        self.hidden = NO;
    }else{
        self.hidden = NO;
    }
}
/**
 设置左上角 右上角圆角
 */
-(void)zh_setCornerRadiusTop:(CGFloat)cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
}
/**
 设置左下角 右下角圆角
 */
-(void)zh_setCornerRadiusBottom:(CGFloat)cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
}
/**
 设置左上角 右下角圆角
 */
-(void)zh_setCornerRadiusNegative:(CGFloat)cornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
}
- (void)addTapActionWithBlock:(GestureActionBlock)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

/// 为本view添加边线
- (void)zh_addLineDirection:(LineDirection)direction BackgroundColor:(UIColor *)color HeightOrWidth:(NSInteger)heightOrwidth{
    
    if (direction & LineDirectionTop) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(heightOrwidth));
        }];
    }
    
    if (direction & LineDirectionBottom) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(heightOrwidth));
        }];
    }
    
    if (direction & LineDirectionLeft) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(heightOrwidth));
            make.left.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
    }
    
    if (direction & LineDirectionRight) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(heightOrwidth));
            make.right.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
    }
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    if (isHorizonal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/// 根据颜色数组生成渐变色背景
- (void)zh_gradientColorFromColors:(NSArray*)colors gradientType:(ZhGradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case ZhGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case ZhGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case ZhGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case ZhGradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    if ([self isKindOfClass:[UIImageView class]]) {
        UIImageView *imageV = (UIImageView *)self;
        imageV.image = image;
    } else {
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
}

/// 根据颜色数组生成渐变色背景
- (void)zh_gradientColorLayerFromColors:(NSArray*)colors gradientType:(ZhGradientType)gradientType{
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    layer.colors = ar;
    //(0,0) (1.0,0)表示水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case ZhGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, 1.0);
            break;
        case ZhGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(1.0, 0.0);
            break;
        case ZhGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(1.0, 1.0);
            break;
        case ZhGradientTypeUprightToLowleft:
            start = CGPointMake(1.0, 0.0);
            end = CGPointMake(0.0, 1.0);
            break;
        default:
            break;
    }
    
    layer.startPoint = start;
    layer.endPoint = end;
    //frame要和view本身的frame相同
    layer.frame = self.frame;
    [self.layer insertSublayer:layer atIndex:0];
}

- (UIViewController *)zh_viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}

- (UINavigationController *)zh_navigationController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
            
        }
        next = next.nextResponder;
    } while (next);
    return nil;
    
}
- (UITabBarController *)zh_tabBarController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

@end
