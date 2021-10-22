//
//  UIImageView+ZhExt.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/4/19.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//
typedef void(^MyImageBlock)(UIImage * _Nullable image);

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ZhExt)

/// 封装的设置UIImageView图片(拼接图片地址) 可自定义预览图
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImageStr:(NSString *)imageName;

/// 封装的设置UIImageView图片(拼接图片地址) 可自定义预览图
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImage:(UIImage *)image;

/// 封装的设置UIImageView图片(拼接图片地址)
- (void)zh_setImageWithUrl:(NSString *)url;

/// 封装的设置UIImageView图片(拼接图片地址) 成功后的回调
- (void)zh_setImageWithUrl:(NSString *)url succeed:(void(^)(void))succeed;

/// 封装的设置UIImageView图片(拼接图片地址) 成功后的回调
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImage:(nullable UIImage *)image succeed:(nullable void(^)(void))succeed;

/// 加载本地的gif图或者图片
- (void)zh_setLocalImage:(NSString *)imgName;

/// 图片合成(上下文重绘)
- (void)zh_setImageSynthesisWithWebUrlArr:(NSArray *)urls;

/// 图片合成(添加子控件)
- (void)zh_setNewImageSynthesisWithWebUrlArr:(NSArray *)urls;

/// 设置Gif图通过NSData数据 (不需要网络)
- (void)zh_showGifImageWithData:(NSData *)imgData;

/// 设置Gif图通过URL路径 (需要网络)
- (void)zh_showGifImageWithURL:(NSURL *)imgUrl;

/// 根据指定路径加载Gif图   <本地路径(可以加载沙盒中的路径)>
- (void)zh_showGifImageWithPath:(NSString *)path;

///根据名字加载Gif图  <如果是Gif图需要加.gif拓展>
- (void)zh_showGifImageWithName:(NSString *)imageName;

/// 根据视频url获取封面图像
- (void)getVideoThumbnailImageFromWeb:(NSString *)videoUrl second:(NSTimeInterval)second;

/// 根据本地视频路径获取缩略图
/// @param videoUrl 本地视频路径
/// @param second 显示的秒数
/// @param getThumbnail 是否需要缩略图
/// @param size 填你得视频的尺寸为最佳
- (void)getVideoThumbnailImageFromlocal:(NSString *)videoUrl second:(CGFloat)second getThumbnail:(BOOL)getThumbnail size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
