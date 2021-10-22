//
//  ZhImageTool.m
//  WeDriveCoach
//
//  Created by zhangzhihua-imac on 2019/11/5.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "ZhImageTool.h"

@implementation ZhImageTool

/// 图片压缩 UIImage->UIImage
+ (void)compressImageToImage:(UIImage *)orignalImage imageKB:(CGFloat)fImageKBytes imageBlock:(ImageBlock)dataBlock{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //二分法压缩图片
        CGFloat compression = 1;
        __block NSData *imageData = UIImageJPEGRepresentation(orignalImage, compression);
        NSUInteger fImageBytes = fImageKBytes*1000;
        if (imageData.length <= fImageBytes){
            dispatch_async(dispatch_get_main_queue(), ^{
                dataBlock(imageData);
            });
            return;
        }
        //这里二分之前重绘一下，就能解决掉内存的不足导致的问题。
        UIImage *newImage = [self createImageForData:imageData maxPixelSize:MAX((NSUInteger)orignalImage.size.width, (NSUInteger)orignalImage.size.height)];
        [self halfFuntionImage:newImage maxSizeByte:fImageBytes back:^(NSData *halfImageData, CGFloat compress) {
            //再一步绘制压缩处理
            UIImage *resultImage = [UIImage imageWithData:halfImageData];
            imageData = halfImageData;
            while (imageData.length > fImageBytes) {
                CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
                //使用NSUInteger不然由于精度问题，某些图片会有白边
                CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                         (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
                resultImage = [self createImageForData:imageData maxPixelSize:MAX(size.width, size.height)];
                imageData = UIImageJPEGRepresentation(resultImage, compress);
            }
            //   整理后的图片尽量不要用UIImageJPEGRepresentation方法转换，后面参数1.0并不表示的是原质量转换。
            dispatch_async(dispatch_get_main_queue(), ^{
                dataBlock(imageData);
            });
        }];
    });
}

/// 图片压缩 UIImage->NSString
+ (void)compressImageToStr:(UIImage *)orignalImage imageKB:(CGFloat)fImageKBytes imageBlock:(ImageStrBlock)strBlock{
    [self compressImageToImage:orignalImage imageKB:fImageKBytes imageBlock:^(NSData * _Nullable imageData) {
        NSString *imgStr = [imageData base64EncodedStringWithOptions:0];
        strBlock(imgStr);
    }];
}

#pragma mark --------------二分法
+ (void)halfFuntionImage:(UIImage *)image maxSizeByte:(NSInteger)maxSizeByte back:(void(^)(NSData *halfImageData, CGFloat compress))block {
    //二分法压缩图片
    CGFloat compression = 1;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    CGFloat max = 1;
    CGFloat min = 0;
    //指数二分处理，s首先计算最小值
    compression = pow(2, -6);
    imageData = UIImageJPEGRepresentation(image, compression);
    if (imageData.length < maxSizeByte) {
        //二分最大10次，区间范围精度最大可达0.00097657；最大6次，精度可达0.015625
        for (int i = 0; i < 6; i++) {
            compression = (max + min) / 2;
            imageData = UIImageJPEGRepresentation(image, compression);
            //容错区间范围0.9～1.0
            if (imageData.length < maxSizeByte * 0.9) {
                min = compression;
            } else if (imageData.length > maxSizeByte) {
                max = compression;
            } else {
                break;
            }
        }
    }
    if (block) {
        block(imageData, compression);
    }
}

+ (UIImage *)createImageForData:(NSData *)data maxPixelSize:(NSUInteger)size {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
          (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
          (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
          (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
    });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}



@end
