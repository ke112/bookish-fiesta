//
//  UIDevice+ZhExt.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UIDevice+ZhExt.h"
@import CoreTelephony;
#import <sys/utsname.h>
#import <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AFNetworking/AFNetworking.h>

@implementation UIDevice (ZhExt)

#pragma mark ====== phone的数据 ======

+ (NSString *)zh_phoneUUID {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
+ (NSString *)zh_phoneName {
    return [UIDevice currentDevice].name;
}
+ (NSString *)zh_phoneModel {
    return [UIDevice currentDevice].model;
}
+ (NSString *)zh_phoneLocalizedModel {
    return [UIDevice currentDevice].localizedModel;
}
+ (NSString *)zh_phoneSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}
+ (NSString *)zh_phoneSystemName {
    return [UIDevice currentDevice].systemName;
}
+ (UIDeviceBatteryState)zh_phoneBatteryState {
    return [UIDevice currentDevice].batteryState;
}
+ (float)zh_phoneBatteryLevel {
    return [UIDevice currentDevice].batteryLevel;
}
+ (NSString *)zh_phoneDefaultLanguage{
    NSString *languageCode = [NSLocale preferredLanguages][0];// 返回的也是国际通用语言Code+国际通用国家地区代码
    NSString *countryCode = [NSString stringWithFormat:@"-%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    if (languageCode) {
        languageCode = [languageCode stringByReplacingOccurrencesOfString:countryCode withString:@""];
    }
    return languageCode;
}

#pragma mark ====== app的数据 ======

+ (NSString *)zh_appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)zh_appBuildNo {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
+ (NSString *)zh_appBundleID{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}
+ (NSString *)zh_appDisplayName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

#pragma mark ====== 存储 ======
/// totalDisk : 总共大小
+ (NSUInteger)zh_diskTotalSpace{
    NSDictionary *fAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
    return [[fAttributes objectForKey:NSFileSystemSize] unsignedIntegerValue];
}
/// totalDisk : 总共大小描述
+ (NSString *)zh_diskTotalSpaceDescribtion{
    return [self p_getSizeFromString:[self zh_diskTotalSpace]];
}

/// freeDisk : 空闲大小
+ (NSUInteger)zh_diskFreeSpace{
    NSDictionary *fAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:NULL];
    return [[fAttributes objectForKey:NSFileSystemFreeSize] unsignedIntegerValue];
}
/// freeDisk : 空闲大小描述
+ (NSString *)zh_diskFreeSpaceDescribtion{
    return [self p_getSizeFromString:[self zh_diskFreeSpace]];
}

/// 得到规格化的存储大小
/// @param size 原始大小
+ (NSString *)p_getSizeFromString:(NSUInteger)size{
    if (size>1024*1024*1024) {
        return [NSString stringWithFormat:@"%.1fGB",size/1024.f/1024.f/1024.f];   //大于1G转化成G单位字符串
    }
    if (size<1024*1024*1024 && size>1024*1024) {
        return [NSString stringWithFormat:@"%.1fMB",size/1024.f/1024.f];   //转成M单位
    }
    if (size>1024 && size<1024*1024) {
        return [NSString stringWithFormat:@"%.1fkB",size/1024.f]; //转成K单位
    }else {
        return [NSString stringWithFormat:@"%.1luB",(unsigned long)size];   //转成B单位
    }
    
}

#pragma mark ====== 网络 ======
/// 获取当前网络类型(通过Reachability)
+ (ZhDeviceNetworkStatus)zh_currentNetworkStatus{
    ZhDeviceNetworkStatus network = ZhDeviceNetworkStatusUnknown;
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
        case AFNetworkReachabilityStatusUnknown:
            network = ZhDeviceNetworkStatusUnknown;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            network = ZhDeviceNetworkStatusNotReachable;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            network = ZhDeviceNetworkStatusReachableViaWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            network = ZhDeviceNetworkStatusReachableViaWiFi;
            break;
        default:
            break;
    }
    return network;
    
}

///  开始监听网络
+ (void)zh_networkStatusWithBlock:(ZhDeviceNetworkStatusBlock)newStatus {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                newStatus ? newStatus(ZhDeviceNetworkStatusUnknown) : nil;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                newStatus ? newStatus(ZhDeviceNetworkStatusNotReachable) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                newStatus ? newStatus(ZhDeviceNetworkStatusReachableViaWWAN) : nil;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                newStatus ? newStatus(ZhDeviceNetworkStatusReachableViaWiFi) : nil;
                break;
            default:
                break;
        }
    }];

}

/// 有网YES, 无网:NO
+ (BOOL)zh_isNetwork{
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

/// 手机网络:YES, 反之:NO
+ (BOOL)zh_isWWANNetwork{
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

/// WiFi网络:YES, 反之:NO
+ (BOOL)zh_isWiFiNetwork{
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}

/// 是否开启飞行模式
+ (BOOL)zh_isAirPlane{
    if ([self zh_isSIMInstalled]) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
        if (@available(iOS 12.0, *)) {
            if (!networkInfo.serviceCurrentRadioAccessTechnology) {
                //飞行模式
                return YES;
            } else {
                return NO;
            }
        }else{
            if(!networkInfo.currentRadioAccessTechnology){
                //飞行模式
                return YES;
            }else{
                return NO;
            }
        }
    } else {
        //没有插卡,就去判断有没有网络
        return ![self zh_isNetwork];
    }
}

/// 是否安装了SIM卡
+ (BOOL)zh_isSIMInstalled{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];

    if (!carrier.isoCountryCode) {
        NSLog(@"No sim present Or No cellular coverage or phone is on airplane mode.");
        return NO;
    }
    return YES;
}

#pragma mark ====== Wifi ======

/// WiFi开关是否打开
+ (BOOL)zh_isWifiEnable{
    //如果是飞行模式,一定是NO
    NSString *const WIFI_INTERFACE_NAME = @"awdl0";
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:WIFI_INTERFACE_NAME] > 1 ? YES : NO;
}

/// 获取Wifi信息
+ (NSDictionary *)zh_wifiInfo{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    return info;
}
/// 获取WIFI名字
+ (NSString *)zh_wifiName{
    return (NSString *)[self zh_wifiInfo][@"SSID"];
}
/// 获取WIFi的Mac地址
+ (NSString *)zh_wifiMacAddress{
    return (NSString *)[self zh_wifiInfo][@"BSSID"];
}
/// 获取Wifi信号强度
+ (int)zh_wifiSignalStrength{
    int signalStrength = 0;
//    判断类型是否为WIFI
    if ([[self class] zh_currentNetworkStatus] == ZhDeviceNetworkStatusReachableViaWiFi) {
//        判断是否为iOS 13
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
             
            id statusBar = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                    statusBar = [localStatusBar performSelector:@selector(statusBar)];
                }
            }
#pragma clang diagnostic pop
            if (statusBar) {
                id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                id wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                if ([wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
//                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                    
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
                }
            }
        }else {
            UIApplication *app = [UIApplication sharedApplication];
            id statusBar = [app valueForKey:@"statusBar"];
            if ([[self class] isLiuHaiScreen]) {
//                刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                       
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
//                    dBm
//                    int rawValue = [[wifiEntry valueForKey:@"rawValue"] intValue];
                }else {
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                        }
                    }
                }
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                     
                NSArray *subviews = [foregroundView subviews];
                NSString *dataNetworkItemView = nil;
                       
                for (id subview in subviews) {
                    if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                        dataNetworkItemView = subview;
                        break;
                    }
                }
                       
                signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
                        
                return signalStrength;
            }
        }
    }
    return signalStrength;
}

/// macAddress
+ (NSString *)zh_MacAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Error: Memory allocation error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2\n");
        free(buf); // Thanks, Remy "Psy" Demerest
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return outstring;
}

///手机运营商
+ (ZhOperatorType)zh_operatorType{
    ZhOperatorType operatorType;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if (carrier) {
        NSString *code = carrier.mobileCountryCode;
        if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
            operatorType = ZhOperatorTypeChinaMobile;
        } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
            operatorType = ZhOperatorTypeChinaUnicom;
        } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"]) {
            operatorType = ZhOperatorTypeChinaTelecom;
        } else if ([code isEqualToString:@"20"]) {
            operatorType = ZhOperatorTypeChinaTietong;
        } else {
            operatorType = ZhOperatorTypeUnKnown;
        }
    } else {
        operatorType = ZhOperatorTypeUnKnown;
    }
    
    return operatorType;
}

#pragma mark ====== 当前显示的视图控制器 ======

/// 获取设备当前vc
+(UIViewController *)zh_currentVc{
    UIViewController  *superVC = [[self class] zh_currentRootVc];
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}
/// 获取设备当前window vc
+ (UIViewController *)zh_currentRootVc{
    UIViewController *result = nil;
    UIWindow * window = [self zh_currentkeyWindow];
    if ([window subviews].count > 0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }else{
            result = window.rootViewController;
        }
    }
    return result;
}
/// 获取当前keyWindow
+ (UIWindow *)zh_currentkeyWindow{
    if (@available(iOS 13.0, *)){
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive){
                for (UIWindow *window in windowScene.windows){
                    if (window.isKeyWindow){
                        return window;
                        break;
                    }
                }
            }
        }
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

#pragma mark ====== 判断屏幕 ======

/// 判断是否是刘海屏
+ (BOOL)isLiuHaiScreen{
    BOOL isPhoneX = NO;
    if (@available(iOS 13.0, *)) {
        isPhoneX = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.bottom > 0.0;
    }else if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    return isPhoneX;
}


@end
