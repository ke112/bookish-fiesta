//
//  UIImage+ZhExt.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZhExt)

#pragma mark - 颜色

/// 根据图像生成颜色值
+ (UIImage *)zh_imageWithColor:(UIColor *)color;

/// 根据图像生成颜色值,指定大小
+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - base64
/// 根据图像生成base64编码字符串
- (NSString *)zh_base64Encoding;

///根据图像生成nsdata
- (NSData *)zh_EncodingData;

/// 根据base64编码字符串生成图像
+ (UIImage *)zh_imageWithbase64Str:(NSString *)base64Str;

#pragma mark - 模糊效果
/// 图片模糊效果   0.0 to 1.0
- (UIImage*)zh_imageBlurred:(CGFloat)blurAmount;

/// 设置UIImage的透明度
- (UIImage *)zh_imageAlpha:(CGFloat)alpha;

/// 去除图片白色背景
- (UIImage *)zh_imageToTransparent;

/// 返回圆形图片 直接操作layer.masksToBounds = YES 会比较卡顿
- (UIImage *)zh_circleImage;

/// 图片旋转 radians 旋转角度
- (UIImage *)zh_rotateInRadians:(CGFloat)radians;

#pragma mark - 截图
/// 全屏截图
+ (UIImage *)zh_shotScreen;

/// 截取长图
+ (void)zh_shotAllWithView:(UIView *)view success:(nullable void(^)(UIImage *snapshotImage))success;

/// 截取view中某个区域生成一张图片
+ (UIImage *)zh_shotWithView:(UIView *)view scope:(CGRect)scope;

#pragma mark - 二维码
/** 识别二维码 */
- (NSString *)zh_readQRCode;

/// 根据一个字符串，生成二维码
+ (UIImage *)zh_qrImageForString:(NSString *)string imageWidth:(CGFloat)ImageWidth;

/// 给二维码加 logo 图
+ (UIImage *)zh_qrCodeImage:(UIImage *)codeImage logo:(UIImage *)logo;

#pragma mark - 大小
/// 获取图片大小
+ (double)zh_calulateImageFileSize:(UIImage *)image;

#pragma mark - 保存图片
/**
 保存图片到本地，并读取本地图片信息
 相当于 - (PHFetchResult<PHAsset *> *)saveImageToPhotoLibrary
 */
- (void)zh_saveImageToPhotoLibraryFinish:(void(^)(PHAsset *asset))finish;



@end

NS_ASSUME_NONNULL_END
