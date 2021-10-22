//
//  UIColor+Ext.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/16.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZhExt)

#pragma mark - 通用方法
/// 根据十六进制生成颜色值，默认透明度为1
+ (UIColor *)zh_colorWithHexString:(NSString *)hexString;

/// 根据十六进制生成颜色值，设置透明度
+ (UIColor *)zh_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// 根据RGB生成颜色值，设置透明度
+ (UIColor *)zh_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;

/// 根据RGB生成颜色值，设置透明度
+ (UIColor *)zh_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;

/// 生成随机的颜色，默认透明度为1
+ (UIColor *)zh_randomColor;

/// 生成随机的颜色,设置透明度
+ (UIColor *)zh_randomColorWithAlpha:(CGFloat)alpha;

#pragma mark - 适配暗黑模式
/// 适配暗黑模式颜色   传入的UIColor对象
+ (UIColor *)zh_colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
+ (UIColor *)zh_colorWithLightColorHexString:(NSString *)lighColorHexString DarkColorHexString:(NSString *)darkColorHexString;

/// 适配暗黑模式颜色   颜色传入的是16进制字符串 还有颜色的透明度
+ (UIColor *)zh_colorWithLightColorHexString:(NSString *)lighColorHexString WithLightColorAlpha:(CGFloat)lightAlpha DarkColorHexString:(NSString *)darkColorHexString WithDarkColorAlpha:(CGFloat)darkAlpha;


@end

NS_ASSUME_NONNULL_END
