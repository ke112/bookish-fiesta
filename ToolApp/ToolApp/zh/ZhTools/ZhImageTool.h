//
//  ZhImageTool.h
//  WeDriveCoach
//
//  Created by zhangzhihua-imac on 2019/11/5.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  针对内存爆表出现的压缩失真分层问题的使用工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(NSData * _Nullable imageData);
typedef void(^ImageStrBlock)(NSString * _Nullable imageStr);

NS_ASSUME_NONNULL_BEGIN

@interface ZhImageTool : NSObject


/// 图片压缩 UIImage->UIImage
/// @param orignalImage 原始图片
/// @param fImageKBytes 最终限制
/// @param dataBlock 处理之后的数据返回，data类型
+ (void)compressImageToImage:(UIImage *)orignalImage imageKB:(CGFloat)fImageKBytes imageBlock:(ImageBlock)dataBlock;

/// 图片压缩 UIImage->NSString
/// @param orignalImage 原始图片
/// @param fImageKBytes 最终限制
/// @param strBlock 处理之后的数据返回，str类型
+ (void)compressImageToStr:(UIImage *)orignalImage imageKB:(CGFloat)fImageKBytes imageBlock:(ImageStrBlock)strBlock;


@end

NS_ASSUME_NONNULL_END
