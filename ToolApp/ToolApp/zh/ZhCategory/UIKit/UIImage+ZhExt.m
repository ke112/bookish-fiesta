//
//  UIImage+ZhExt.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import "UIImage+ZhExt.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#if __has_include(<TYSnapshotScroll/TYSnapshotScroll.h>)
#import <TYSnapshotScroll/TYSnapshotScroll.h>
#elif __has_include("TYSnapshotScroll.h")
#import "TYSnapshotScroll.h"
#endif

@implementation UIImage (ZhExt)


#pragma mark - 颜色
/**
 根据图像生成颜色值
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color
{
    return [UIImage zh_imageWithColor:color size:CGSizeMake(1, 1)];
}
/**
 根据图像生成颜色值,指定大小
 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (color == nil) {
        return nil;
    }
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


#pragma mark - base64
/**
 根据图像生成base64编码字符串
 */
- (NSString *)zh_base64Encoding {
    NSData *imageData = UIImageJPEGRepresentation(self, 0.5f);
    NSString *imageStr = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return imageStr;
}
/**
   根据图像生成nsdata
 */
- (NSData *)zh_EncodingData{
    NSData *imageData = UIImageJPEGRepresentation(self, 0.5f);
    return imageData;
}
/**
 根据base64编码字符串生成图像
 */
+ (UIImage *)zh_imageWithbase64Str:(NSString *)base64Str {
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *imageFinal = [UIImage imageWithData:imageData];
    return imageFinal;
}

#pragma mark - 模糊效果
/**
 图片模糊效果   0.0 to 1.0
 */
- (UIImage*)zh_imageBlurred:(CGFloat)blurAmount{
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    }
    
    if (error) {
#ifdef DEBUG
//        NSLog(@"%s error: %zd", __PRETTY_FUNCTION__, error);
#endif
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}
/**
 设置UIImage的透明度
 */
- (UIImage *)zh_imageAlpha:(CGFloat)alpha{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)zh_imageToTransparent{
    
    // 分配内存
    const int imageWidth = self.size.width;
    const int imageHeight = self.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        //        //去除白色...将0xFFFFFF00换成其它颜色也可以替换其他颜色。
        //        if ((*pCurPtr & 0xFFFFFF00) >= 0xffffff00) {
        //            uint8_t* ptr = (uint8_t*)pCurPtr;
        //            ptr[0] = 0;
        //        }
        //接近白色 //将像素点转成子节数组来表示---第一个表示透明度即ARGB这种表示方式。ptr[0]:透明度,ptr[1]:R,ptr[2]:G,ptr[3]:B
        //分别取出RGB值后。进行判断需不需要设成透明。
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if (ptr[1] > 240 && ptr[2] > 240 && ptr[3] > 240) { //当RGB值都大于240则比较接近白色的都将透明度设为0.-----即接近白色的都设置为透明。某些白色背景具有杂质就会去不干净，用这个方法可以去干净
            ptr[0] = 0;
        }
    }
    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
/**
 返回圆形图片 直接操作layer.masksToBounds = YES 会比较卡顿
 */
- (UIImage *)zh_circleImage{
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    // 裁剪
    CGContextClip(ctx);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 图片旋转 radians 旋转角度
 */
- (UIImage *)zh_rotateInRadians:(CGFloat)radians{
    if (!(&vImageRotate_ARGB8888)) return nil;
    const size_t width = self.size.width;
    const size_t height = self.size.height;
    const size_t bytesPerRow = width * 4;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, space, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(space);
    if (!bmContext) return nil;
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    UInt8* data = (UInt8*)CGBitmapContextGetData(bmContext);
    if (!data){ CGContextRelease(bmContext); return nil; }
    vImage_Buffer src = {data, height, width, bytesPerRow};
    vImage_Buffer dest = {data, height, width, bytesPerRow};
    Pixel_8888 bgColor = {0, 0, 0, 0};
    vImageRotate_ARGB8888(&src, &dest, NULL, radians, bgColor, kvImageBackgroundColorFill);
    CGImageRef rotatedImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* rotated = [UIImage imageWithCGImage:rotatedImageRef];
    CGImageRelease(rotatedImageRef);
    CGContextRelease(bmContext);
    return rotated;
}


#pragma mark - 截图
/**
 全屏截图
 */
+ (UIImage *)zh_shotScreen{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 截取长图
+ (void)zh_shotAllWithView:(UIView *)view success:(nullable void(^)(UIImage *snapshotImage))success{
//   [TYSnapshotScroll screenSnapshot:view finishBlock:^(UIImage *snapshotImage) {
//       if (success) {
//           success(snapshotImage);
//       }
//   }];
}
/**
 截取view中某个区域生成一张图片
 */
+ (UIImage *)zh_shotWithView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)zh_shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self zh_shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

#pragma mark - 二维码
/** 识别二维码 */
- (NSString *)zh_readQRCode{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:self.CIImage];
    
    NSString *result;
    if (features.count) {
        CIQRCodeFeature *feature = [features firstObject];
        result = feature.messageString;
    } else {
        result = nil;
    }
    return result;
}
+ (UIImage *)zh_qrImageForString:(NSString *)string imageWidth:(CGFloat)ImageWidth{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];  //二维码滤镜
    [filter setDefaults]; //恢复滤镜的默认属性
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [self zh_createUIImageFormCIImage:outPutImage withSize:ImageWidth];
}
+ (UIImage *)zh_createUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)ImageWidth{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(ImageWidth/CGRectGetWidth(extent), ImageWidth/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
    
}
+ (UIImage *)zh_getImageFromView:(UIView *)theView
{
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, theView.layer.contentsScale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIView *)zh_getViewWithImage:(UIImage *)image size:(CGSize)size{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat x = size.width * 0.1;
    CGFloat y = size.height * 0.1;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, size.width-2*x, size.height-2*y)];
    [imageView setImage:image];
    [view addSubview:imageView];
    return view;
}
+ (UIImage *)zh_qrCodeImage:(UIImage *)codeImage logo:(UIImage *)logo{
    //给二维码加 logo 图
    CGSize size = codeImage.size;
    CGSize logoSize = CGSizeMake(size.width*0.382, size.height*0.382);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    [codeImage drawInRect:CGRectMake(0,0 , size.width, size.height)];
    //logo图加白边
    logo = [self zh_getImageFromView:[self zh_getViewWithImage:logo size:logoSize]];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [logo drawInRect:CGRectMake((size.width-logoSize.width)/2.0, (size.height-logoSize.height)/2.0, logoSize.width, logoSize.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
#pragma mark - 大小
/// 获取图片大小
+ (double)zh_calulateImageFileSize:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        /// 实际上, UIImageJPEGRepresentation这个函数获取到的图片文件大小并不准确
        /// 后面的参数改为 0.7才大概是原图片的文件大小
        data = UIImageJPEGRepresentation(image, 0.7);
    }
    return [data length] * 1.0;
}

#pragma mark - 保存图片
/**
 保存图片到本地，并读取本地图片信息
 
 相当于 - (PHFetchResult<PHAsset *> *)saveImageToPhotoLibrary
 */
- (void)zh_saveImageToPhotoLibraryFinish:(void(^)(PHAsset *asset))finish {
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:self];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //成功后取相册中的图片对象
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            if (finish) finish([result firstObject]);
        }
    }];
}


@end
