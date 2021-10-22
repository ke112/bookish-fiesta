//
//  NetWorkTool.m
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/16.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#define defaultTimeout 45

#import "NetWorkTool.h"
#import <AFNetworking/AFNetworking.h>
#import "UIDevice+ZhExt.h"

static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

@implementation NetWorkTool

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = defaultTimeout;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    /*    设置请求头    */
    [_sessionManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    [_sessionManager.requestSerializer setValue:[UIDevice zh_appVersion] forHTTPHeaderField:@"version"];
    [_sessionManager.requestSerializer setValue:[UIDevice zh_phoneSystemVersion] forHTTPHeaderField:@"sysVersion"];
    [_sessionManager.requestSerializer setValue:@"SRXL" forHTTPHeaderField:@"channel"];
    [_sessionManager.requestSerializer setValue:[UIDevice zh_phoneModel] forHTTPHeaderField:@"deviceInfo"];
    [_sessionManager.requestSerializer setValue:@"c" forHTTPHeaderField:@"userTag"];
    [_sessionManager.requestSerializer setValue:[UIDevice zh_phoneDefaultLanguage] forHTTPHeaderField:@"language"];
}


/**
 封装的业务 POST请求
 */
+ (__kindof NSURLSessionDataTask *)POST:(NSString *)interface
                         parameters:(nullable id)parameters
                        showLoading:(BOOL)showLoading
                            success:(RequestSucceedBlock)requestSuccess
                            failure:(RequestFailBlock)requestFail{
//    [_sessionManager.requestSerializer setValue:kUserInfo.token forHTTPHeaderField:@"token"];
    _sessionManager.requestSerializer.timeoutInterval = defaultTimeout;
//    KKLog(@"token : %@",kUserInfo.token);
    
    NSString *requetURL = [NSString stringWithFormat:@"%@",interface];
    requetURL = [requetURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:[parameters zh_JSONString] forKey:@"json"];
    
    if (showLoading) {
        
    }
//    KKLog(@"POST请求的路径:  %@   参数: %@",requetURL,parameters == nil ? @"" : [param zh_JSONString]);
    NSURLSessionDataTask *sessionTask = [_sessionManager POST:requetURL parameters:param headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestSuccess([responseObject objectForKey:@"data"]);
            });
        }{
            KKLog(@"请求成功 但status != 200:\n%@\n %@",parameters,responseObject);
            NSError *error = [[NSError alloc]init];
            requestFail(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestFail(error);
        KKLog(@"请求失败的 接口: %@ 入参: %@ 错误码: %ld 错误原因: %@",interface,param,error.code,error.description);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;

    return sessionTask;
}

/**
 封装的业务 GET请求
 */
+ (__kindof NSURLSessionDataTask *)GET:(NSString *)interface
                        parameters:(nullable id)parameters
                        showLoading:(BOOL)showLoading
                           success:(RequestSucceedBlock)requestSuccess
                               failure:(RequestFailBlock)requestFail{
    return [self GET:interface parameters:parameters showLoading:showLoading showError:YES success:requestSuccess failure:requestFail];
}

/**
 封装的业务 GET请求 (如果成功了非200 401是否提示用户信息 )
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)interface
                        parameters:(nullable id)parameters
                       showLoading:(BOOL)showLoading
                         showError:(BOOL)isShowError
                           success:(RequestSucceedBlock)requestSuccess
                           failure:(RequestFailBlock)requestFail{
//    [_sessionManager.requestSerializer setValue:kUserInfo.token forHTTPHeaderField:@"token"];
    _sessionManager.requestSerializer.timeoutInterval = defaultTimeout;
//    KKLog(@"token : %@",kUserInfo.token);
    
    NSString *requetURL = [NSString stringWithFormat:@"%@",interface];
    requetURL = [requetURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:[parameters zh_JSONString] forKey:@"json"];
    
    if (showLoading) {
        
    }
//    KKLog(@"POST请求的路径:  %@   参数: %@",requetURL,parameters == nil ? @"" : [param zh_JSONString]);
    NSURLSessionDataTask *sessionTask = [_sessionManager GET:requetURL parameters:param headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestSuccess([responseObject objectForKey:@"data"]);
            });
        }{
            KKLog(@"请求成功 但status != 200:\n%@\n %@",parameters,responseObject);
            NSError *error = [[NSError alloc]init];
            requestFail(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestFail(error);
        KKLog(@"请求失败的 接口: %@ 入参: %@ 错误码: %ld 错误原因: %@",interface,param,error.code,error.description);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;

    return sessionTask;
}
/**
封装的业务 PUT请求
*/
+ (__kindof NSURLSessionDataTask *)PUT:(NSString *)interface
                        parameters:(nullable id)parameters
                       showLoading:(BOOL)showLoading
                           success:(RequestSucceedBlock)requestSuccess
                           failure:(RequestFailBlock)requestFail{
//    [_sessionManager.requestSerializer setValue:kUserInfo.token forHTTPHeaderField:@"token"];
    _sessionManager.requestSerializer.timeoutInterval = defaultTimeout;
//    KKLog(@"token : %@",kUserInfo.token);
    
    NSString *requetURL = [NSString stringWithFormat:@"%@",interface];
    requetURL = [requetURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setValue:[parameters zh_JSONString] forKey:@"json"];

//    KKLog(@"PUT请求的参数-------%@ \n\n %@",interface,parameters == nil ? @"" : parameters);
    if (showLoading) {
        
    }
    NSURLSessionDataTask *sessionTask = [_sessionManager PUT:requetURL parameters:param headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestSuccess([responseObject objectForKey:@"data"]);
            });
        }{
            KKLog(@"请求成功 但status != 200:\n%@\n %@",parameters,responseObject);
            NSError *error = [[NSError alloc]init];
            requestFail(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestFail(error);
        KKLog(@"请求失败的 接口: %@ 入参: %@ 错误码: %ld 错误原因: %@",interface,param,error.code,error.description);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

/**
封装的业务 Delete请求
*/
+ (__kindof NSURLSessionDataTask *)Delete:(NSString *)interface
                           parameters:(nullable id)parameters
                          showLoading:(BOOL)showLoading
                              success:(RequestSucceedBlock)requestSuccess
                              failure:(RequestFailBlock)requestFail{
    _sessionManager.requestSerializer.timeoutInterval = defaultTimeout;
//    KKLog(@"token : %@",kUserInfo.token);
    
    NSString *requetURL = [NSString stringWithFormat:@"%@",interface];
    requetURL = [requetURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

//    KKLog(@"Delete请求的参数-------%@ \n\n %@",interface,parameters == nil ? @"" : parameters);
    if (showLoading) {
        
    }
    NSURLSessionDataTask *sessionTask = [_sessionManager DELETE:requetURL parameters:param headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestSuccess([responseObject objectForKey:@"data"]);
            });
        }{
            KKLog(@"请求成功 但status != 200:\n%@\n %@",parameters,responseObject);
            NSError *error = [[NSError alloc]init];
            requestFail(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestFail(error);
        KKLog(@"请求失败的 接口: %@ 入参: %@ 错误码: %ld 错误原因: %@",interface,param,error.code,error.description);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

/**
*  封装的业务 上传单/多张图片
*/
+ (__kindof NSURLSessionTask *)uploadImages:(NSString *)interface
                                 parameters:(nullable id)parameters
                                       name:(NSArray<NSString *> *)names
                                     images:(NSArray<NSData *> *)images
                                   progress:(HttpProgress)progress
                                    success:(RequestSucceedBlock)requestSuccess
                                    failure:(RequestFailBlock)requestFail{
    NSString *requetURL = [NSString stringWithFormat:@"%@",interface];
    requetURL = [requetURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    
//    [_sessionManager.requestSerializer setValue:kUserInfo.token forHTTPHeaderField:@"token"];
    _sessionManager.requestSerializer.timeoutInterval = 60.f;
//    KKLog(@"token : %@",kUserInfo.token);
    NSURLSessionTask *sessionTask = [_sessionManager POST:requetURL parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = images[i];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            // 默认图片的文件名
            NSString *imageFileName = [NSString stringWithFormat:@"%@_%ld.%@",str,i,@"jpg"];
            
            NSString *mimeType = [NSString stringWithFormat:@"image/%@",@"jpg"];
            [formData appendPartWithFileData:imageData
                                        name:names[i]
                                    fileName:imageFileName
                                    mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                requestSuccess([responseObject objectForKey:@"data"]);
            });
        }{
            KKLog(@"请求成功 但status != 200:\n%@\n %@",parameters,responseObject);
            NSError *error = [[NSError alloc]init];
            requestFail(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestFail(error);
        KKLog(@"请求失败的 接口: %@ 入参: %@ 错误码: %ld 错误原因: %@",interface,param,error.code,error.description);
    }];
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


+ (BOOL)kisNetwork{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
+ (BOOL)kisWiFiNetwork{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}
+ (BOOL)kisWWANNetwork{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}
+ (void)cancelAllRequest{
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionDataTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}
+ (void)cancelRequestWithURL:(NSString *)URL{
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionDataTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

/// 获取当前网络类型(通过Reachability)
+ (ZhNetworkStatusType)zh_currentNetworkStatus{
    ZhNetworkStatusType network;
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusUnknown:{
            network = ZhNetworkStatusUnknown;
        }break;
        case AFNetworkReachabilityStatusNotReachable:{
            network = ZhNetworkStatusNotReachable;
        }break;
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            network = ZhNetworkStatusReachableViaWWAN;
        }break;
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            network = ZhNetworkStatusReachableViaWiFi;
        }break;
        default:{
            network = ZhNetworkStatusUnknown;
        }break;
    }
    return network;
}

+ (void)networkStatusWithBlock:(ZhNetworkStatus)networkStatus{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(ZhNetworkStatusUnknown) : nil;
                KKLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(ZhNetworkStatusNotReachable) : nil;
                KKLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(ZhNetworkStatusReachableViaWWAN) : nil;
                KKLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(ZhNetworkStatusReachableViaWiFi) : nil;
                KKLog(@"WIFI");
                break;
        }
    }];
}
/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

@end
