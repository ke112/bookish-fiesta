//
//  UIView+ZhExt.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义边框方向枚举
typedef NS_ENUM(NSInteger,LineDirection){
    LineDirectionTop = 1 << 0,
    LineDirectionBottom = 1 << 1,
    LineDirectionLeft = 1 << 2,
    LineDirectionRight = 1 << 3
};
typedef NS_ENUM(NSUInteger, ZhGradientType) {
    ZhGradientTypeTopToBottom = 0,//从上到小
    ZhGradientTypeLeftToRight = 1,//从左到右
    ZhGradientTypeUpleftToLowright = 2,//左上到右下
    ZhGradientTypeUprightToLowleft = 3,//右上到左下
};

NS_ASSUME_NONNULL_BEGIN
typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (ZhExt)
/**
 set_get_x
 */
@property (nonatomic, assign)CGFloat x;
/**
 set_get__y
 */
@property (nonatomic, assign)CGFloat y;
/**
 set_get_left
 */
@property (nonatomic) CGFloat left;
/**
 set_get_top
 */
@property (nonatomic) CGFloat top;
/**
 set_get_width
 */
@property (nonatomic, assign)CGFloat width;
/**
 set_get_height
 */
@property (nonatomic, assign)CGFloat height;
/**
 set_get_centerX
 */
@property (nonatomic, assign)CGFloat centerX;
/**
 set_get_centerY
 */
@property (nonatomic, assign)CGFloat centerY;
/**
 set_get_origin
 */
@property (nonatomic, assign)CGPoint origin;
/**
 set_get_size
 */
@property (nonatomic, assign)CGSize size;
/**
 get_MaxX
 */
@property (nonatomic,assign)CGFloat maxX;
/**
 get_MaxY
 */
@property (nonatomic,assign)CGFloat maxY;
/**
 set_get_MaxX
 */
@property (nonatomic) CGFloat right;
/**
 set_get_MaxY
 */
@property (nonatomic) CGFloat bottom;

/// 自定义方法圆角
@property (nonatomic, assign)CGFloat zh_CornerRadius;

/// 自定义方法切为圆形
@property (nonatomic, assign) BOOL zh_Circle;

/// 自定义边框颜色
- (void)zh_setBorderCorlor:(UIColor *)borderCorlor borderWidth:(CGFloat)width;

/// 自定义设置阴影效果
- (void)zh_setShadowColorWith:(UIColor *)color offSet:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;

/// 设置统一阴影效果
- (void)zh_setShadowColor;

/// 取消阴影效果
- (void)zh_setCancelShadowColor;

/// 隐藏视图 是否存在动画效果
- (void)hiddenWithAnimation:(BOOL)HasAnimation;

/// 显示视图 是否存在动画效果
- (void)showWithAnimation:(BOOL)HasAnimation;

/// 设置左上角 右上角圆角
-(void)zh_setCornerRadiusTop:(CGFloat)cornerRadius;

/// 设置左下角 右下角圆角
-(void)zh_setCornerRadiusBottom:(CGFloat)cornerRadius;

/// 设置左上角 右下角圆角
-(void)zh_setCornerRadiusNegative:(CGFloat)cornerRadius;

///单击事件 block回调
- (void)addTapActionWithBlock:(GestureActionBlock)block;

/// 为本view添加边线
- (void)zh_addLineDirection:(LineDirection)direction BackgroundColor:(UIColor *)color HeightOrWidth:(NSInteger)heightOrwidth;

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
+ (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;

/// 根据颜色数组生成渐变色背景
- (void)zh_gradientColorFromColors:(NSArray*)colors gradientType:(ZhGradientType)gradientType imgSize:(CGSize)imgSize;

/// 根据颜色数组生成渐变色背景
- (void)zh_gradientColorLayerFromColors:(NSArray*)colors gradientType:(ZhGradientType)gradientType;

/// 获取当前控制器
- (UIViewController *)zh_viewController;

/// 获取当前navigationController
- (UINavigationController *)zh_navigationController;

/// 获取当前tabBarController
- (UITabBarController *)zh_tabBarController;


@end

NS_ASSUME_NONNULL_END
