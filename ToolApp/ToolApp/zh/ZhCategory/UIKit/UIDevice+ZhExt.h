//
//  UIDevice+ZhExt.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  获取设备信息

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZhOperatorType) {
    ZhOperatorTypeUnKnown, /// 未知运营商
    ZhOperatorTypeChinaMobile,/// 移动运营商
    ZhOperatorTypeChinaUnicom,/// 联通运营商
    ZhOperatorTypeChinaTelecom,///  电信运营商
    ZhOperatorTypeChinaTietong,/// 铁通运营商
};

typedef NS_ENUM(NSInteger, ZhDeviceNetworkStatus) {
    ZhDeviceNetworkStatusNotReachable = 0, /// 无网络
    ZhDeviceNetworkStatusReachableViaWWAN = 1, /// 手机网络
    ZhDeviceNetworkStatusReachableViaWiFi = 2, /// WIFI网络
    ZhDeviceNetworkStatusUnknown = 3  /// 未知网络
};
/// 网络状态的Block
typedef void(^ZhDeviceNetworkStatusBlock)(ZhDeviceNetworkStatus status);

@interface UIDevice (ZhExt)

#pragma mark ====== phone的数据 ======

/// UUIDString : 得到当前设备独一标识符 DA6586A1-C0F4-43B9-AAA5-43476A5F3BA6
+ (NSString *)zh_deviceUUID;

/// phoneName : 当前的设备名称，关于本机里面的名称
+ (NSString *)zh_deviceName;

/// phoneModel : 当前的设备型号
+ (NSString *)zh_deviceModel;

/// localizedModel : 模型的本地化版本
+ (NSString *)zh_deviceLocalizedModel;

/// systemVersion : 14.4
+ (NSString *)zh_deviceSystemVersion;

/// systemName : 当前系统名称
+ (NSString *)zh_deviceSystemName;

/// batteryState : 充电的状态 0未知  1没有插电源  2插了电源不到100%  3插了电源充电100%
+ (UIDeviceBatteryState)zh_deviceBatteryState;

/// batteryLevel : 当前电池量 0~1
+ (float)zh_deviceBatteryLevel;

/// language : 获取默认系统语言 zh-Hans
+ (NSString *)zh_deviceDefaultLanguage;

#pragma mark ====== app的数据 ======

/// appVersion : 7.0.2
+ (NSString *)zh_appVersion;

/// appBuildNo : 1
+ (NSString *)zh_appBuildNo;

/// 获取BundleID
+ (NSString *)zh_appBundleID;

/// 获取app的名字
+ (NSString *)zh_appDisplayName;

#pragma mark ====== 硬盘存储 ======

/// totalDisk : 总共大小
+ (NSUInteger)zh_diskTotalSpace;
/// totalDisk : 总共大小描述
+ (NSString *)zh_diskTotalSpaceDescribtion;

/// freeDisk : 空闲大小
+ (NSUInteger)zh_diskFreeSpace;
/// freeDisk : 空闲大小描述
+ (NSString *)zh_diskFreeSpaceDescribtion;

#pragma mark ====== 网络 ======

/// 获取当前网络类型
+ (ZhDeviceNetworkStatus)zh_currentNetworkStatus;

///  开始监听网络
+ (void)zh_networkStatusWithBlock:(ZhDeviceNetworkStatusBlock)newStatus;

/// 有网YES, 无网:NO
+ (BOOL)zh_isNetwork;

/// 手机网络:YES, 反之:NO
+ (BOOL)zh_isWWANNetwork;

/// WiFi网络:YES, 反之:NO
+ (BOOL)zh_isWiFiNetwork;

/// 是否开启飞行模式
+ (BOOL)zh_isAirPlane;

/// 是否安装了SIM卡
+ (BOOL)zh_isSIMInstalled;

#pragma mark ====== Wifi ======

/// WiFi开关是否打开
+ (BOOL)zh_isWifiEnable;

/// 获取Wifi信息
+ (NSDictionary *)zh_wifiInfo;

/// 获取WIFI名字
+ (NSString *)zh_wifiName;

/// 获取WIFi的Mac地址
+ (NSString *)zh_wifiMacAddress;

/// 获取Wifi信号强度 1 2 3,默认无wifi为0
+ (int)zh_wifiSignalStrength;

/// macAddress
+ (NSString *)zh_MacAddress;

///手机运营商
+ (ZhOperatorType)zh_operatorType;

#pragma mark ====== 当前显示的视图控制器 ======

/// 获取设备当前vc
+ (UIViewController *)zh_currentVc;

/// 获取设备当前根视图控制器
+ (UIViewController *)zh_currentRootVc;

/// 获取当前keyWindow
+ (UIWindow *)zh_currentkeyWindow;

#pragma mark ====== 判断屏幕 ======

/// 判断是否是刘海屏
+ (BOOL)isLiuHaiScreen;


@end

NS_ASSUME_NONNULL_END
