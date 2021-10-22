//
//  UIImageView+ZhExt.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/4/19.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UIImageView+ZhExt.h"
#import <ImageIO/ImageIO.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/SDImageCache.h>
#import "UIImage+ZhExt.h"
#import "NSString+ZhExt.h"

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define ARCCompatibleAutorelease(object) object
#else
#define toCF (CFTypeRef)
#define ARCCompatibleAutorelease(object) [object autorelease]
#endif

@implementation UIImageView (ZhExt)

/**
 封装的设置UIImageView图片(拼接图片地址) 可自定义预览图
 */
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImageStr:(NSString *)imageName{
    [self zh_setImageWithUrl:url WithPlaceImage:![NSString zh_isEmptyString:imageName] ? [UIImage imageNamed:imageName] : nil succeed:nil];
}
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImage:(UIImage *)image{
    [self zh_setImageWithUrl:url WithPlaceImage:image succeed:nil];
}
- (void)zh_setImageWithUrl:(NSString *)url{
    [self zh_setImageWithUrl:url WithPlaceImage:nil succeed:nil];
}
- (void)zh_setImageWithUrl:(NSString *)url succeed:(void(^)(void))succeed{
    [self zh_setImageWithUrl:url WithPlaceImage:nil succeed:^{
        succeed();
    }];
}
/**
 封装的设置UIImageView图片(拼接图片地址) 成功后的回调
 */
- (void)zh_setImageWithUrl:(NSString *)url WithPlaceImage:(nullable UIImage *)image succeed:(nullable void(^)(void))succeed{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    
    UIImage *placeImg = [UIImage zh_imageWithColor:kColorWithHex(@"0xF5F5F5")];
//    if ([NSString zh_isEmptyString:url]) {
//        self.image = placeImg;
//        return;
//    }
    url = [url zh_utf8_Encoding];
    if ([url containsString:@"http"]) {
        NSURL *nsurl = [NSURL URLWithString:url];
        [self sd_setImageWithURL:nsurl placeholderImage:image ? : placeImg options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (succeed) {
                succeed();
            }
        }];
    }else{
        NSURL *nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
        [self sd_setImageWithURL:nsurl placeholderImage:image ? : placeImg options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (succeed) {
                succeed();
            }
        }];
    }
}

/// 加载本地的gif图或者图片
- (void)zh_setLocalImage:(NSString *)imgName{
    NSString *lastPath = [[imgName componentsSeparatedByString:@"/"] lastObject];
    NSString *tupianName = [[lastPath componentsSeparatedByString:@"."] firstObject];
    NSString *tupianType = [[lastPath componentsSeparatedByString:@"."] lastObject];
    if ([lastPath hasSuffix:@"gif"]) {
        NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:tupianName ofType:@"gif"];
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        self.image = [UIImage sd_imageWithGIFData:imageData];
    }else{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:tupianName ofType:tupianType];
        self.image = [UIImage imageWithContentsOfFile:filePath];
    }
}
/**
 图片合成
 */
- (void)zh_setImageSynthesisWithWebUrlArr:(NSArray *)urls{
    
    UIImage *originImage = self.image;
    UIGraphicsBeginImageContextWithOptions(originImage.size ,NO, 0.0);
    
    CGFloat margin = 10;
    CGFloat length = originImage.size.height;
    CGFloat width = (originImage.size.width-margin)/2;
    CGFloat height = (originImage.size.height-margin)/2;
    
    UIImageView *webImgView = [[UIImageView alloc]init];
    webImgView.clipsToBounds = YES;
    webImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (urls.count == 1) {
        [webImgView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
        [webImgView.image drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
        
    } else if (urls.count == 2) {
        for (int i=0; i<urls.count; i++) {
            [webImgView sd_setImageWithURL:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            [webImgView.image drawInRect:CGRectMake(i%2*(width+margin), 0, width, length)];
        }
    } else if (urls.count == 3) {
        for (int i=0; i<urls.count; i++) {
            [webImgView sd_setImageWithURL:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            if (i == 0) {
                [webImgView.image drawInRect:CGRectMake(0, 0, width, originImage.size.height)];
            } else {
                [webImgView.image drawInRect:CGRectMake(width+margin, (i+1)%2*(margin+height), width, height)];
            }
        }
    } else if (urls.count >= 4) {
        for (int i=0; i<urls.count; i++) {
            if (i > 3) {
                break;
            }
            [webImgView sd_setImageWithURL:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            [webImgView.image drawInRect:CGRectMake(i%2*(width+margin), i/2*(height+margin), width, height)];
        }
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = resultingImage;
}

- (void)zh_setNewImageSynthesisWithWebUrlArr:(NSArray *)urls{
    CGFloat length = 84;
    
    CGFloat margin = 2;
    CGFloat width = (length-margin)/2;
    CGFloat height = (length-margin)/2;
    
    for (UIImageView *webImgView in self.subviews) {
        [webImgView removeFromSuperview];
    }
    
    if (urls.count == 1) {
        UIImageView *webImgView = [[UIImageView alloc]init];
        webImgView.clipsToBounds = YES;
        webImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:webImgView];
        
        //        [webImgView sd_zh_setImageWithUrl:[NSURL URLWithString:urls[0]] placeholderImage:nil];
        [webImgView zh_setImageWithUrl:urls[0]];
        webImgView.frame = CGRectMake(0, 0, length, length);
        
    } else if (urls.count == 2) {
        for (int i=0; i<urls.count; i++) {
            UIImageView *webImgView = [[UIImageView alloc]init];
            webImgView.clipsToBounds = YES;
            webImgView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:webImgView];
            
            //            [webImgView sd_zh_setImageWithUrl:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            [webImgView zh_setImageWithUrl:urls[i]];
            webImgView.frame = CGRectMake(i%2*(width+margin), 0, width, length);
        }
    } else if (urls.count == 3) {
        for (int i=0; i<urls.count; i++) {
            UIImageView *webImgView = [[UIImageView alloc]init];
            webImgView.clipsToBounds = YES;
            webImgView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:webImgView];
            
            //            [webImgView sd_zh_setImageWithUrl:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            [webImgView zh_setImageWithUrl:urls[i]];
            if (i == 0) {
                webImgView.frame = CGRectMake(0, 0, width, length);
            } else {
                webImgView.frame = CGRectMake(width+margin, (i+1)%2*(margin+height), width, height);
            }
        }
    } else if (urls.count >= 4) {
        for (int i=0; i<urls.count; i++) {
            if (i > 3) {
                break;
            }
            UIImageView *webImgView = [[UIImageView alloc]init];
            webImgView.clipsToBounds = YES;
            webImgView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:webImgView];
            //            [webImgView sd_zh_setImageWithUrl:[NSURL URLWithString:urls[i]] placeholderImage:nil];
            [webImgView zh_setImageWithUrl:urls[i]];
            webImgView.frame = CGRectMake(i%2*(width+margin), i/2*(height+margin), width, height);
        }
    }
}

/**
 根据名字加载Gif图
 */
- (void)zh_showGifImageWithName:(NSString *)imageName{
    if([imageName hasSuffix:@".gif"]){
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        [self zh_showGifImageWithPath:path];
    }else{
        self.image = [UIImage imageNamed:imageName];
    }
}
/**
 根据指定路径加载Gif图
 */
- (void)zh_showGifImageWithPath:(NSString *)path{
    __weak id __self = self;
    NSURL * url = [[NSURL alloc]initFileURLWithPath:path];
    [self zh_getGifImageWithUrl:url returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层添加
        [[(UIImageView *)__self layer]addAnimation:animation forKey:@"gifAnimation"];
    }];
}
//通过文件路径返回Gif图相关数据
- (void)zh_getGifImageWithUrl:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}


/**
 设置Gif图通过NSData数据
 */
- (void)zh_showGifImageWithData:(NSData *)imgData {
    NSTimeInterval duration = [self durationForGifData:imgData];
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF imgData, NULL);
    [self zh_animatedGIFImageSource:source andDuration:duration];
    CFRelease(source);
}

/**
 设置Gif图通过URL路径
 */
- (void)zh_showGifImageWithURL:(NSURL *)imgUrl {
    NSData *data = [NSData dataWithContentsOfURL:imgUrl];
    [self zh_showGifImageWithData:data];
}

//根据NSData数据展示Gif动画
- (void)zh_animatedGIFImageSource:(CGImageSourceRef) source
                   andDuration:(NSTimeInterval) duration {
    
    
    if (!source) return;
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return;
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    [self setAnimationImages:images];
    [self setAnimationDuration:duration];
    [self startAnimating];
}
//获取NSData数据的时长
- (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration=0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes
                                                                        length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            NSArray *arr = @[@32,@4,@123,@4,@5,@2];
            //            [durationData getBytes:buffer];
            [durationData getBytes:buffer length:arr.count * sizeof(arr)];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    return duration/100;
}

/// 根据视频url获取封面图像
- (void)getVideoThumbnailImageFromWeb:(NSString *)videoUrl second:(NSTimeInterval)second{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    //先从缓存中查找是否有图片
    SDImageCache *cache =  [SDImageCache sharedImageCache];
    UIImage *memoryImage =  [cache imageFromMemoryCacheForKey:videoURL.absoluteString];
    if (memoryImage) {
        self.image = memoryImage;
        return;
    }else{
        //再从磁盘中查找是否有图片
        UIImage *diskImage =  [cache imageFromDiskCacheForKey:videoURL.absoluteString];
        if (diskImage) {
            self.image = diskImage;
            return;
        }
    }
    if (!second) {
        second = 1;
    }
    //如果都不存在，开启异步线程截取对应时间点的画面，转成图片缓存至磁盘
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = second;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SDImageCache * cache =  [SDImageCache sharedImageCache];
            [cache storeImage:thumbnailImage forKey:videoURL.absoluteString toDisk:YES completion:nil];
            self.image = thumbnailImage;
        });
        
    });
}

/// 根据本地视频路径获取缩略图
/// @param videoUrl 本地视频路径
/// @param second 显示的秒数
/// @param getThumbnail 是否需要缩略图
/// @param size 填你得视频的尺寸为最佳
- (void)getVideoThumbnailImageFromlocal:(NSString *)videoUrl second:(CGFloat)second getThumbnail:(BOOL)getThumbnail size:(CGSize)size{
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    NSURL *videoURL = [NSURL fileURLWithPath:videoUrl];
    if (!videoURL){
        NSLog(@"WARNING:videoURL为空");
        return;
    }
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    /*
     如果不需要获取缩略图，就设置为NO，如果需要获取缩略图，则maximumSize为获取的最大尺寸。
     以BBC为例，getThumbnail = NO时，打印宽高数据为：1920*1072。
     getThumbnail = YES时，maximumSize为100*100。打印宽高数据为：100*55.
     注：不乘[UIScreen mainScreen].scale，会发现缩略图在100*100很虚。
     */
    if (getThumbnail){
        CGFloat width = [UIScreen mainScreen].scale * size.width;
        CGFloat height = [UIScreen mainScreen].scale * size.height;
        imageGenerator.maximumSize =  CGSizeMake(height, width);
    }
    NSError *error = nil;
    CMTime time = CMTimeMake(second,1);
    CMTime actucalTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"ERROR:获取视频图片失败,%@",error.domain);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    NSLog(@"imageWidth=%f,imageHeight=%f",image.size.width,image.size.height);
    CGImageRelease(cgImage);
    self.image = image;
}

@end
