//
//  ZhMapNavigator.h
//  经测试,高德 百度 苹果地图(国内) 谷歌地图(国内) 是非常准的!
//  Created by 张志华 on 2019/6/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  urlScheme需要根据项目单独配置

//<key>LSApplicationQueriesSchemes</key>
//<array>
//    <string>qqmap</string>
//    <string>baidumap</string>
//    <string>iosamap</string>
//    <string>comgooglemaps</string>
//</array>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface ZhMapNavigator : UIView

/// 使用手机上的地图软件导航
/// @param endLocation 目的地经纬度(GCJ-02))
/// @param superVC 当前的控制器
+ (void)mapNavigatorWithEndLocation:(CLLocationCoordinate2D)endLocation andViewController:(UIViewController *)superVC;

/// 使用指定地图App,开始导航
/// @param mapType 地图类型 eg: @"高德地图"
/// @param coordinate 目的地经纬度(GCJ-02))
+ (void)navigatorWithType:(NSString *)mapType toLocation:(CLLocationCoordinate2D)endLocation;


/// 获取本机的地图App
+ (NSArray *)getLocalMaps;

/// 打开路径地址
+ (void)openURL:(NSString *)url;



@end
