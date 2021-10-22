

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CAGradientLayerDirection) {
    CAGradientLayerDirection_FromLeftToRight,           // 从左到右
    CAGradientLayerDirection_FromTopToBottom,           // 从上到下
    CAGradientLayerDirection_FromTopLeftToBottomRight,  // 从左上到右下
    CAGradientLayerDirection_FromTopRightToBottomLeft,  // 从右上到左下
    CAGradientLayerDirection_FromCenterToEdge,          // 从中心向四周
};

@interface UIView (ZhDrawCategory)

/// 画直线
/// @param fPoint 开始点
/// @param tPoint 结束点
/// @param color 线的颜色
/// @param height 线的高度
- (void)zh_drawLineFromPoint:(CGPoint)fPoint
                     toPoint:(CGPoint)tPoint
                   lineColor:(UIColor *)color
                  lineHeight:(CGFloat)height;

/// 画虚线
/// @param fPoint 开始点
/// @param tPoint 结束点
/// @param color 线的颜色
/// @param width 线的宽度
/// @param height 线的高度
/// @param space 线的间隙
/// @param type  0 -是方形, 1是切圆
- (void)zh_drawDashLineFromPoint:(CGPoint)fPoint
                         toPoint:(CGPoint)tPoint
                       lineColor:(UIColor *)color
                       lineWidth:(CGFloat)width
                      lineHeight:(CGFloat)height
                       lineSpace:(CGFloat)space
                        lineType:(NSInteger)type;

/// draw pentagram in view. rate: 0.3 ~ 1.1
- (void)zh_drawPentagram:(CGPoint)center
                  radius:(CGFloat)radius
                   color:(UIColor *)color
                    rate:(CGFloat)rate;

/// draw rect. type: 0 - cube, 1 - round
- (void)zh_drawRect:(CGRect)rect
          lineColor:(UIColor *)color
          lineWidth:(CGFloat)width
         lineHeight:(CGFloat)height
           lineType:(NSInteger)type
             isDash:(BOOL)dash
          lineSpace:(CGFloat)space;


/// 生成渐变色
/// @param rect frame设置
/// @param colors 颜色数组
/// @param locations 区域分割数组 (而locations并不是表示颜色值所在位置,它表示的是颜色在Layer坐标系相对位置处要开始进行渐变颜色了)
/// @param direction 渐变方向
- (CALayer *)zh_gradientLayer:(CGRect)rect
                        color:(NSArray <UIColor *>*)colors
                     location:(NSArray <NSNumber *> *)locations
                    direction:(CAGradientLayerDirection)direction;


/// 生成渐变色, 可设置渐变模式
/// @param rect frame设置
/// @param colors 颜色数组
/// @param direction 渐变方向
/// @param locations 区域分割数组 (而locations并不是表示颜色值所在位置,它表示的是颜色在Layer坐标系相对位置处要开始进行渐变颜色了)
/// @param type 0是方形 1是切圆形
- (CALayer *)zh_gradientLayer:(CGRect)rect
                        color:(NSArray <UIColor *>*)colors
                    direction:(CAGradientLayerDirection)direction
                     location:(NSArray <NSNumber *> *)locations
                         type:(NSInteger)type;

/// draw oval. type: 0 - cube, 1 - round
- (void)zh_drawOval:(CGRect)rect
          lineColor:(UIColor *)color
          lineWidth:(CGFloat)width
         lineHeight:(CGFloat)height
           lineType:(NSInteger)type
             isDash:(BOOL)dash
          lineSpace:(CGFloat)space;

/// draw round rect. type: 0 - cube, 1 - round
- (void)zh_drawRoundRect:(CGRect)rect
               lineColor:(UIColor *)color
               lineWidth:(CGFloat)width
              lineHeight:(CGFloat)height
                lineType:(NSInteger)type
                  isDash:(BOOL)dash
               lineSpace:(CGFloat)space
                  radius:(CGFloat)radius;

/// draw round rect. type: 0 - cube, 1 - round
- (void)zh_drawRoundRect:(CGRect)rect
         roundingCorners:(UIRectCorner)corners
               lineColor:(UIColor *)color
               lineWidth:(CGFloat)width
              lineHeight:(CGFloat)height
                lineType:(NSInteger)type
                  isDash:(BOOL)dash
               lineSpace:(CGFloat)space
                  radius:(CGFloat)radius;

@end
