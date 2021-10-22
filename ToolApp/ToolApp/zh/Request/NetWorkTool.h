//
//  NetWorkTool.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/16.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//  网络请求工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResultModel.h"

#define defaultNetError @"网络请求失败,请再次尝试"
#define defaultNoNet    @"似乎已断开与互联网的连接"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZhNetworkStatusType) {
    /// 未知网络
    ZhNetworkStatusUnknown = 1000,
    /// 无网络
    ZhNetworkStatusNotReachable = 1001,
    /// 手机网络
    ZhNetworkStatusReachableViaWWAN = 1002,
    /// WIFI网络
    ZhNetworkStatusReachableViaWiFi = 1003
};

typedef void(^RequestSucceedBlock)(id responseObject);
typedef void(^RequestFailBlock)(NSError *error);
typedef void(^RequestCacheBlock)(id responseCache);
typedef void (^HttpProgress)(NSProgress *progress);
typedef void(^ZhNetworkStatus)(ZhNetworkStatusType status);

@interface NetWorkTool : NSObject

@property(nonatomic,copy)RequestSucceedBlock requestSucceedBlock; //成功block
@property(nonatomic,copy)RequestFailBlock requestFailBlock;       //失败block
@property(nonatomic,copy)RequestCacheBlock responseCacheBlock;    //缓存Block

/**
 封装的业务 POST请求
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)interface
                         parameters:(nullable id)parameters
                        showLoading:(BOOL)showLoading
                            success:(RequestSucceedBlock)requestSuccess
                            failure:(RequestFailBlock)requestFail;

/**
 封装的业务 GET请求
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)interface
                        parameters:(nullable id)parameters
                       showLoading:(BOOL)showLoading
                           success:(RequestSucceedBlock)requestSuccess
                           failure:(RequestFailBlock)requestFail;
/**
 封装的业务 GET请求 (如果成功了非200 401是否提示用户信息 )
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)interface
                        parameters:(nullable id)parameters
                       showLoading:(BOOL)showLoading
                         showError:(BOOL)isShowError
                           success:(RequestSucceedBlock)requestSuccess
                           failure:(RequestFailBlock)requestFail;

/**
 封装的业务 PUT请求
 */
+ (__kindof NSURLSessionTask *)PUT:(NSString *)interface
                        parameters:(nullable id)parameters
                       showLoading:(BOOL)showLoading
                           success:(RequestSucceedBlock)requestSuccess
                           failure:(RequestFailBlock)requestFail;

/**
 封装的业务 Delete请求
 */
+ (__kindof NSURLSessionTask *)Delete:(NSString *)interface
                           parameters:(nullable id)parameters
                          showLoading:(BOOL)showLoading
                              success:(RequestSucceedBlock)requestSuccess
                              failure:(RequestFailBlock)requestFail;

/**
 *  封装的业务 上传单/多张图片
 */
+ (__kindof NSURLSessionTask *)uploadImages:(NSString *)interface
                                 parameters:(nullable id)parameters
                                       name:(NSArray<NSString *> *)names
                                     images:(NSArray<NSData *> *)images
                                   progress:(HttpProgress)progress
                                    success:(RequestSucceedBlock)requestSuccess
                                    failure:(RequestFailBlock)requestFail;

/**
 一次性判断是否有网的宏
 */
+ (BOOL)kisNetwork;
/**
 一次性判断是否为WiFi网络的宏
 */
+ (BOOL)kisWiFiNetwork;
/**
 一次性判断是否为手机网络的宏
 */
+ (BOOL)kisWWANNetwork;
/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;
/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/// 获取当前网络类型
+ (ZhNetworkStatusType)zh_currentNetworkStatus;
/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(ZhNetworkStatus)networkStatus;


@end

NS_ASSUME_NONNULL_END
