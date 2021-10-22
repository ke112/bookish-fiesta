//
//  UIColor+Ext.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/16.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import "UIColor+ZhExt.h"

@implementation UIColor (ZhExt)

#pragma mark - 通用方法
//html的颜色一般是：#FF9900、0xFF9900,上边的方法需要处理
+ (UIColor *)zh_colorWithHexString:(NSString *)hexString{
    
    return [self zh_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)zh_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    NSString * cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString * rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString * gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString * bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)zh_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue{
    return [self zh_colorWithR:red G:green B:blue alpha:1];
}
+ (UIColor *)zh_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red>1?red/255.0:red
                           green:green>1?green/255.0:green
                            blue:blue>1?blue/255.0:blue alpha:alpha];
}

+ (UIColor *)zh_randomColor {
    return [UIColor zh_randomColorWithAlpha:1.0];
}

+ (UIColor *)zh_randomColorWithAlpha:(CGFloat)alpha {
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    return [UIColor zh_colorWithR:R/255.0 G:G/255.0 B:B/255.0 alpha:alpha];
}

#pragma mark - 适配暗黑模式
/// 适配暗黑模式颜色   传入的UIColor对象
+ (UIColor *)zh_colorWithLightColor:(UIColor *)lightColor DarkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
    } else {
        return lightColor ? lightColor : (darkColor ? darkColor : [UIColor clearColor]);
    }
}

/// 适配暗黑模式颜色   颜色传入的是16进制字符串
+ (UIColor *)zh_colorWithLightColorHexString:(NSString *)lighColorHexString DarkColorHexString:(NSString *)darkColorHexString{
    return [UIColor zh_colorWithLightColor:[UIColor zh_colorWithHexString:lighColorHexString] DarkColor:[UIColor zh_colorWithHexString:darkColorHexString]];
}


/// 适配暗黑模式颜色   颜色传入的是16进制字符串 还有颜色的透明度
+ (UIColor *)zh_colorWithLightColorHexString:(NSString *)lighColorHexString WithLightColorAlpha:(CGFloat)lightAlpha DarkColorHexString:(NSString *)darkColorHexString WithDarkColorAlpha:(CGFloat)darkAlpha{
    return [UIColor zh_colorWithLightColor:[UIColor zh_colorWithHexString:lighColorHexString alpha:lightAlpha] DarkColor:[UIColor zh_colorWithHexString:darkColorHexString alpha:darkAlpha]];
}


@end
