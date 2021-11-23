//
//  UIDevice+ZhExt.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UIDevice+ZhExt.h"
@import CoreTelephony;
#import <sys/utsname.h>//设备型号
#import <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <Reachability/Reachability.h>

static const NSString *simulatorIndentify = @"Simulator";

@implementation UIDevice (ZhExt)


#pragma mark ====== phone的数据 ======

+ (NSString *)zh_deviceUUID {
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
+ (NSString *)zh_deviceName {
    return [UIDevice currentDevice].name;
}
+ (NSString *)zh_deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE (1st generation)";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceModel isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceModel isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone12,8"])   return @"iPhone SE (2st generation)";
    if ([deviceModel isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([deviceModel isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([deviceModel isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([deviceModel isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    if ([deviceModel isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
    if ([deviceModel isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
    if ([deviceModel isEqualToString:@"iPhone14,2"])   return @"iPhone 13 Pro";
    if ([deviceModel isEqualToString:@"iPhone14,3"])   return @"iPhone 13 Pro Max";
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch (1st generation)";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch (2st generation)";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch (3st generation)";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch (4st generation)";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5st generation)";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch (6st generation)";
    if ([deviceModel isEqualToString:@"iPod9,1"])      return @"iPod Touch (7st generation)";
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 (2st generation)";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 (2st generation)";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
    if ([deviceModel isEqualToString:@"iPad8,1"])      return @"iPad Pro 11";
    if ([deviceModel isEqualToString:@"iPad8,2"])      return @"iPad Pro 11";
    if ([deviceModel isEqualToString:@"iPad8,3"])      return @"iPad Pro 11";
    if ([deviceModel isEqualToString:@"iPad8,4"])      return @"iPad Pro 11";
    if ([deviceModel isEqualToString:@"iPad8,5"])      return @"iPad Pro 12.9 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad8,6"])      return @"iPad Pro 12.9 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad8,7"])      return @"iPad Pro 12.9 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad8,8"])      return @"iPad Pro 12.9 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad8,9"])      return @"iPad Pro 11 (2st generation)";
    if ([deviceModel isEqualToString:@"iPad8,10"])     return @"iPad Pro 11 (2st generation)";
    if ([deviceModel isEqualToString:@"iPad8,11"])     return @"iPad Pro 12.9 (4st generation)";
    if ([deviceModel isEqualToString:@"iPad8,12"])     return @"iPad Pro 12.9 (4st generation)";
    if ([deviceModel isEqualToString:@"iPad11,1"])     return @"iPad Mini (5st generation)";
    if ([deviceModel isEqualToString:@"iPad11,2"])     return @"iPad Mini (5st generation)";
    if ([deviceModel isEqualToString:@"iPad11,3"])     return @"iPad Air (3st generation)";
    if ([deviceModel isEqualToString:@"iPad11,4"])     return @"iPad Air (3st generation)";
    if ([deviceModel isEqualToString:@"iPad13,1"])     return @"iPad Air (4st generation)";
    if ([deviceModel isEqualToString:@"iPad13,2"])     return @"iPad Air (4st generation)";
    if ([deviceModel isEqualToString:@"iPad13,4"])     return @"iPad Pro 11 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad13,5"])     return @"iPad Pro 11 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad13,6"])     return @"iPad Pro 11 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad13,7"])     return @"iPad Pro 11 (3st generation)";
    if ([deviceModel isEqualToString:@"iPad13,8"])     return @"iPad Pro 12.9 (5st generation)";
    if ([deviceModel isEqualToString:@"iPad13,9"])     return @"iPad Pro 12.9 (5st generation)";
    if ([deviceModel isEqualToString:@"iPad13,10"])    return @"iPad Pro 12.9 (5st generation)";
    if ([deviceModel isEqualToString:@"iPad13,11"])    return @"iPad Pro 12.9 (5st generation)";
    if ([deviceModel isEqualToString:@"iPad14,1"])     return @"iPad Mini (6st generation)";
    if ([deviceModel isEqualToString:@"iPad14,2"])     return @"iPad Mini (6st generation)";

    if ([deviceModel isEqualToString:@"AppleTV1,1"])      return @"Apple TV";
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV (2st generation)";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV (3st generation)";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV (3st generation)";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV (4st generation)";
    if ([deviceModel isEqualToString:@"AppleTV6,2"])      return @"Apple TV 4K";
    if ([deviceModel isEqualToString:@"AppleTV11,1"])      return @"Apple TV 4K (2st generation)";

    if ([deviceModel isEqualToString:@"i386"])         return simulatorIndentify;
    if ([deviceModel isEqualToString:@"x86_64"])       return simulatorIndentify;
    return deviceModel;
}
+ (NSString *)zh_deviceLocalizedModel {
    return [UIDevice currentDevice].localizedModel;
}
+ (NSString *)zh_deviceSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}
+ (NSString *)zh_deviceSystemName {
    return [UIDevice currentDevice].systemName;
}
+ (UIDeviceBatteryState)zh_deviceBatteryState {
    return [UIDevice currentDevice].batteryState;
}
+ (float)zh_deviceBatteryLevel {
    return [UIDevice currentDevice].batteryLevel;
}
+ (NSString *)zh_deviceDefaultLanguage{
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
    ZhDeviceNetworkStatus network = ZhDeviceNetworkStatusNotReachable;
    NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            network = ZhDeviceNetworkStatusNotReachable;
            break;
        case ReachableViaWWAN:
            network = ZhDeviceNetworkStatusReachableViaWWAN;
            break;
        case ReachableViaWiFi:
            network = ZhDeviceNetworkStatusReachableViaWiFi;
            break;
        default:
            break;
    }
    return network;
}

/// 有网YES, 无网:NO
+ (BOOL)zh_isNetwork{
    return [Reachability reachabilityForInternetConnection].isReachable;
}

/// 手机网络:YES, 反之:NO
+ (BOOL)zh_isWWANNetwork{
    return [Reachability reachabilityForInternetConnection].isReachableViaWWAN;
}

/// WiFi网络:YES, 反之:NO
+ (BOOL)zh_isWiFiNetwork{
    return [Reachability reachabilityForInternetConnection].isReachableViaWiFi;
}

/// 是否开启飞行模式(判断的方法不准)
+ (BOOL)zh_isAirPlane{
//    if ([self zh_isSIMInstalled]) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc]init];
        if (@available(iOS 12.0, *)) {
            if (networkInfo.serviceCurrentRadioAccessTechnology != nil) {
                return NO;
            } else {
                //飞行模式
                return YES;
            }
        }else{
            if(!networkInfo.currentRadioAccessTechnology){
                //飞行模式
                return YES;
            }else{
                return NO;
            }
        }
//    } else {
//        //没有插卡,就去判断有没有网络
//        return ![self zh_isNetwork];
//    }
}

/// 是否安装了SIM卡
+ (BOOL)zh_isSIMInstalled{
    //先排除模拟器
    if ([[self zh_deviceModel] isEqualToString:simulatorIndentify]) {
        return NO;
    }
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    if (!carrier.isoCountryCode) {
        return NO;
    }
    return YES;
}

///手机运营商
+ (ZhOperatorType)zh_operatorType{
    ZhOperatorType operatorType;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    if (carrier) {
        NSString *code = carrier.mobileNetworkCode;
//        NSString *name = carrier.carrierName; //中国移动 中国联通 中国电信
//        NSString *countryCode = carrier.mobileCountryCode; //都是460
        if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
            operatorType = ZhOperatorTypeChinaMobile;
        } else if ([code isEqualToString:@"01"] || [code isEqualToString:@"06"]) {
            operatorType = ZhOperatorTypeChinaUnicom;
        } else if ([code isEqualToString:@"03"] || [code isEqualToString:@"05"] || [code isEqualToString:@"11"]) {
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
    return info ? : @{};
}
/// 获取WIFI名字
+ (NSString *)zh_wifiName{
    NSString *wifiName = (NSString *)[self zh_wifiInfo][@"SSID"];
    return wifiName ? : @"";
}
/// 获取WIFi的Mac地址
+ (NSString *)zh_wifiMacAddress{
    NSString *wifiMacAddress = (NSString *)[self zh_wifiInfo][@"BSSID"];
    return wifiMacAddress ? : @"";
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


#pragma mark ====== 当前显示的视图控制器 ======

/// 获取当前显示的vc
+(UIViewController *)zh_currentShowVc{
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
/// 获取当前根视图控制器vc
+ (UIViewController *)zh_currentRootVc{
    UIViewController *result = nil;
    UIWindow *window = [self zh_currentkeyWindow];
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
