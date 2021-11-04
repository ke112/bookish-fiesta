//
//  SuperWebView.h
//  zhangzhihua
//
//  Created by zhangzhihua on 2019/3/6.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperWebView : UIView


/**
 加载网络Url地址
 
 @param frame CGRect位置
 @param webUrlAddress Web路径地址
 @param superView superView可不传，使用约束显示位置
 @param funcNames 注册方法名（Web调用原生）
 @param eventBlock 注册方法回调
 @return 返回值为UIView实例，用于添加到可见视图; 如果传入superView，返回值可不取。
 */
+ (instancetype)loadWebUrlWithFrame:(CGRect)frame webUrlAddress:(NSString *)webUrlAddress superView:(nonnull UIView *)superView registerFuncWebToNative:(nullable NSArray<NSString *> *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock;

/**
 加载本地html网页
 
 @param frame CGRect位置
 @param localUrlName 本地html文件名
 @param superView superView可不传，使用约束显示位置
 @param funcNames 注册方法名（Web调用原生）
 @param eventBlock 注册方法回调
 @return 返回值为UIView实例，用于添加到可见视图; 如果传入superView，返回值可不取。
 */
+ (instancetype)loadLocalUrlWithFrame:(CGRect)frame localUrlName:(NSString *)localUrlName superView:(nonnull UIView *)superView registerFuncWebToNative:(nullable NSArray<NSString *> *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock;

/// 加载webview
/// @param frame CGRect位置
/// @param webUrl 网络Url地址
/// @param localUrlName 本地html名称
/// @param funcNames 注册方法名（Web调用原生）
/// @param eventBlock 注册方法回调
- (instancetype)initWithFrame:(CGRect)frame webUrl:(NSString *)webUrl localUrlName:(NSString *)localUrlName registerFuncWebToNative:(NSArray *)funcNames eventBlock:(void(^)(NSInteger index,id param))eventBlock;
/**
 原生执行JS脚本调用Web
 
 @param JavaScript 要执行的JS脚本代码
 @param completionHandler 执行完JS脚本后的回调
 */
- (void)evaluateJavaScript:(NSString *)JavaScript completion:(void(^)(id data, NSError * error))completionHandler;

/**
 原生调用JS方法,可传参数
 
 @param func JS方法名
 @param param 传的参数
 @param completionHandler 执行完JS脚本后的回调
 */
- (void)evaluateWebFunc:(NSString *)func param:(nullable NSDictionary *)param completion:(void(^)(id data, NSError * error))completionHandler;

/// webview返回
- (BOOL)webViewCanBack;

/// webview返回列表的数量
@property (nonatomic, copy) void (^backForwardListBlock)(NSInteger count);

/**
 加载完成的回调
 */
@property (nonatomic, copy) void (^loadFinishBlock)(void);

/// 回调的标题
@property (nonatomic, copy) void (^titleBlock)(NSString *title);



@end

NS_ASSUME_NONNULL_END
