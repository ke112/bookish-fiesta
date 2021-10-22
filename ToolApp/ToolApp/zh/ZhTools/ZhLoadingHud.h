//
//  ZhLoadingHud.h
//  Consultant
//
//  Created by 张志华 on 5/31/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhLoadingHud : NSObject

/// 菊花框
+ (void)showHudAddedTo:(nullable UIView *)view;

/// 隐藏hud
+ (void)hideHud;

/// 只显示文字    (默认中间)
+ (void)showHint:(NSString *)hint addedTo:(nullable UIView *)view;

/// 菊花框+文字
+ (void)showHudWithHint:(nullable NSString *)hint addedTo:(nullable UIView *)view;

/// 自定义图片+文字
+ (void)showHudWithImage:(NSString *)image hint:(NSString *)hint addedTo:(nullable UIView *)view;

/// 自定义hud风格图片+文字
+ (void)showHudWithImage:(NSString *)image hint:(NSString *)hint addedTo:(nullable UIView *)view yOffset:(float)yOffset;

/// 进度加载圆环 + 文字
+ (void)showHudWithProgress:(CGFloat)progress hint:(NSString *)hint addedTo:(nullable UIView *)view;


@end

NS_ASSUME_NONNULL_END
