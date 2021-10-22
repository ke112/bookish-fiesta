//
//  ZHLocation.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//
//  plist 文件的key : Privacy - Location When In Use Usage Description  需要访问您的位置,获取周边信息
//                   Privacy - Location Always Usage Description       需要访问您的位置,获取周边信息
//                   Privacy - Location Always and When In Use Usage Description 需要访问您的位置,获取周边信息

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ZHLocationModel : NSObject
//WGS-84：国际上的GPS以及iOS定位的坐标系
//GCS-02：国内和高德定位的坐标系（对地图数据进行加密偏移处理）

//eg: country administrativeArea locality subLocality thoroughfare                      name
//show: 中国   河北省              廊坊市    霸州市       迎宾东道与益津中路交汇处               霸州市人民政府
//show: 中国   (null)             北京市    朝阳区       东三环南路                          东三环南路
//show: 中国   (null)             北京市    丰台区       马家堡嘉园二里34号楼(近赵登禹学校小学部) 嘉园北京丰台实验艺术幼儿园

/// 世界标准地理坐标(WGS-84  iphone)     经度
@property (nonatomic, copy) NSString *longitude;
/// 世界标准地理坐标(WGS-84  iphone)     纬度
@property (nonatomic, copy) NSString *latitude;
/// 中国国测局地理坐标（GCJ-02  火星坐标）   经度
@property (nonatomic, copy) NSString *longitude_GCJ02;
/// 中国国测局地理坐标（GCJ-02 火星坐标）   纬度
@property (nonatomic, copy) NSString *latitude_GCJ02;
/// 百度地理坐标（BD-09)    经度
@property (nonatomic, copy) NSString *longitude_Bd09;
/// 百度地理坐标（BD-09)    纬度
@property (nonatomic, copy) NSString *latitude_Bd09;
/// 地点名称
@property (nonatomic, copy) NSString *name;
/// 街道
@property (nonatomic, copy) NSString *thoroughfare;
/** 子街道 */
@property (nonatomic, copy) NSString *subThoroughfare;
/// 地级市 直辖市区
@property (nonatomic, copy) NSString *locality;
/// 县 区
@property (nonatomic, copy) NSString *subLocality;
/// 省 直辖市
@property (nonatomic, copy) NSString *administrativeArea;
/// 子省 直辖市
@property (nonatomic, copy) NSString *subAdministrativeArea;
/// 邮编
@property (nonatomic, copy) NSString *postalCode;
/// CN
@property (nonatomic, copy) NSString *ISOcountryCode;
/// 中国
@property (nonatomic, copy) NSString *country;
///
@property (nonatomic, copy) NSString *inlandWater;
///
@property (nonatomic, copy) NSString *ocean;
/// 位置描述
@property (nonatomic, copy) NSString *locationDescription;

@end


@protocol ZHLocationDelegate <NSObject>

/** 代理方法 获取当前地理位置成功 如果代理方法和block同时实现会优先使用bolck回调 */
- (void)locationDidEndUpdatingLocation:(ZHLocationModel *)location;

/** 代理方法 获取地理位置失败 如果代理方法和block同时实现会优先使用bolck回调 */
- (void)locationdidFailWithError:(NSError *)failure;

@end

typedef void(^locationSuccessHandler)(ZHLocationModel *location);
typedef void(^locationFailureHandler)(NSError *error);
@interface ZHLocation : NSObject

@property (nonatomic, weak) id<ZHLocationDelegate> delegate;

/** 获取定位信息 */
@property (nonatomic, strong, readonly) ZHLocationModel *location;

/** 单利初始化方法 */
+ (instancetype)manager;

/** 定位失败 跳转修改系统权限 */
- (void)requetModifySystemForPermissions;

/** 监测 是否拥有定位权限 */
- (BOOL)locationServicesEnabled;

/** 初始化开始定位 */
- (void)beginUpdatingLocation;

/// 初始化开始定位并且block回调
- (void)beginUpdatingLocationSuccess:(locationSuccessHandler)success
                             failure:(locationFailureHandler)failure;

/// 根据经纬度反向地理编译出地址信息
- (void)reverseGeocodeLocationWithLocation:(CLLocation *)location handler:(locationSuccessHandler)handler;


@end
