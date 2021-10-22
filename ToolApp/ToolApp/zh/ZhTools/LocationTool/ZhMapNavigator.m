//
//  ZhMapNavigator.h
//  经测试,高德 百度 苹果地图(国内) 谷歌地图(国内) 是非常准的!
//  Created by 张志华 on 2019/6/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  urlScheme需要根据项目单独配置

#import "ZhMapNavigator.h"
#include <math.h>

NSString *MapGaodeStr = @"高德地图";
NSString *MapBaiduStr = @"百度地图";
NSString *MapGoogleStr = @"谷歌地图";
NSString *MapAppleStr = @"苹果地图";
NSString *MapTencentStr = @"腾讯地图";

//iOS版本判断
#define iOS8 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)

@interface ZhMapNavigator ()<UIActionSheetDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D toLocation;

@end

@implementation ZhMapNavigator

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return  self;
}

/// 使用手机上的全部地图软件导航
/// @param endLocation 目的地经纬度(GCJ-02))
/// @param superVC 当前的控制器
+ (void)mapNavigatorWithEndLocation:(CLLocationCoordinate2D )endLocation andViewController:(UIViewController *)superVC{
    
    CLLocationCoordinate2D coordinate = endLocation;
    NSArray *maps = [self getLocalMaps];
    
    if (iOS8) {  // ios8以上系统
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *value in maps) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:value style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self navigatorWithType:value toLocation:coordinate];
            }];
            [alert addAction:action];
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [superVC presentViewController:alert animated:YES completion:nil];

    }else{  //ios8 之下的系统
        ZhMapNavigator *navigator = [[ZhMapNavigator alloc] init];
        navigator.toLocation = endLocation;

        UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"选择地图"  delegate:navigator
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil 
                                                  otherButtonTitles:nil];
        for (NSString *value in maps) {
            [alert addButtonWithTitle:value];
        }
        [superVC.view addSubview:navigator];
        [alert showFromRect:superVC.view.bounds inView:superVC.view animated:YES];
    }
}


/// UIActionSheet点击代理方法
/// @param actionSheet UIActionSheet对象
/// @param buttonIndex 点击的下标
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    CLLocationCoordinate2D coordinate = self.toLocation;
    NSString *buttonTitleStr = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    [[self class] navigatorWithType:buttonTitleStr toLocation:coordinate];
    
    [self removeFromSuperview];
}

/// 使用指定地图App,开始导航
/// @param mapType 地图类型 eg: @"高德地图"
/// @param coordinate 目的地经纬度(GCJ-02))
+ (void)navigatorWithType:(NSString *)mapType toLocation:(CLLocationCoordinate2D)endLocation{
    
#warning urlScheme需要根据项目单独配置
    NSString *urlScheme = @"lgwmapnav://";
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *startName = @"我的位置";
    NSString *endName = @"目的地";
    
    if ([mapType isEqualToString:MapAppleStr]) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        currentLocation.name = startName;
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endLocation addressDictionary:nil]];
        toLocation.name = endName;
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }else if ([mapType isEqualToString:MapBaiduStr]){
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin={{%@}}&destination=latlng:%f,%f|name=%@2&mode=driving&coord_type=gcj02",startName,endLocation.latitude, endLocation.longitude,endName];
        [self openURL:urlString];
    }else if ([mapType isEqualToString:MapGaodeStr]){
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&backScheme=%@&sid=BGVIS1&sname=%@&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=0",appName,urlScheme,startName,endLocation.latitude,endLocation.longitude,endName];
        [self openURL:urlString];
    }else if ([mapType isEqualToString:MapGoogleStr]){
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,endLocation.latitude, endLocation.longitude];
        [self openURL:urlString];
    }else if ([mapType isEqualToString:MapTencentStr]){
        NSString *urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=%@&fromcoord=CurrentLocation&to=%@&tocoord=%lf,%lf",startName,endName,endLocation.latitude, endLocation.longitude];
        [self openURL:urlString];
    }
}

/// 获取本机的地图App
+ (NSArray *)getLocalMaps{
    NSMutableArray *maps = [NSMutableArray array];
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        [maps addObject:MapGaodeStr];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        [maps addObject:MapBaiduStr];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]){
        [maps addObject:MapTencentStr];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        [maps addObject:MapGoogleStr];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]){
        [maps addObject:MapAppleStr];
    }
    return maps;
}

/// 打开路径地址
+ (void)openURL:(NSString *)url{
    NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


@end
