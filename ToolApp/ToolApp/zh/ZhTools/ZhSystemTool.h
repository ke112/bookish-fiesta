//
//  SystemEventTool.h
//  WeDriveCoach
//
//  Created by 张志华 on 2019/6/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//定位
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhSystemTool : NSObject

/// 单例实例
+ (instancetype)shared;

/// 打开App Store下载页(app外部)
+ (BOOL)openAppStoreDownloadPage:(NSInteger)appID;

/// 打开App Store下载页(app内部)
+ (void)openAppStoreDownloadPageInApp:(NSInteger)appID;

/// 打开App Store评论页(app外部)
+ (BOOL)openAppStoreReviewsPage:(NSInteger)appID;

/// 打电话
+ (BOOL)callPhone:(NSString *)phone;

/// 发邮件 (目前做的调出APP 邮件应用)
+ (BOOL)sendEmail:(NSString *)emaill;

/// 打开链接
+ (BOOL)openURL:(NSString *)openUrl;

/// 能否打开链接
+ (BOOL)canOpenURL:(NSString *)openUrl;

/// 打开App 隐私设置
+ (BOOL)openAppPrivacySettings;

#pragma mark - 定位 经纬度 邮编相关
 /// 获得系统定位经纬度
- (void)getSystemLocationWithBlock:(void(^)(NSString *lng,NSString *lat))block;


#pragma mark - 震动相关
/// APP震动 (来短信电话的震动)
+ (void)shock;

#pragma mark - UINotificationFeedbackGenerator

/// 通知反馈类型成功
+ (void)shockSuccessFeedback;

/// 通知反馈类型警告
+ (void)shockWarningFeedback;

/// 通知反馈类型错误
+ (void)shockErrorFeedback;

#pragma mark - UIImpactFeedbackGenerator

/// 执行轻度反馈
+ (void)shockLightFeedback;

/// 执行中度反馈
+ (void)shockMediumFeedback;

/// 执行高度反馈
+ (void)shockHeavyFeedback;

/// 执行Soft反馈,iOS13
+ (void)shockSoftFeedback;

/// 执行Rigid反馈,iOS13
+ (void)shockRigidFeedback;

#pragma mark - UISelectionFeedbackGenerator

/// 执行选择反馈 (用来模拟选择滚轮一类控件时的震动)
+ (void)shockSelectionFeedback;

#pragma mark - 钥匙串

/// 钥匙串 存数据
+ (void)saveKeyChain:(NSString *)key data:(id)data;

/// 钥匙串 取数据
+ (id)getKeyChain:(NSString *)key;

/// 钥匙串 删数据
+ (void)deleteKeyChain:(NSString *)key;

#pragma mark - 扬声器
/// 切换扬声器
/// @param isYang 是否打开扬声器
+ (BOOL)turnOnTheSpeaker:(BOOL)isYang;

/// 相册权限检测
+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result;



@end

NS_ASSUME_NONNULL_END
