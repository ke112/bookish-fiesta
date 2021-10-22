//
//  ZHLocation.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//

#import "ZHLocation.h"
#import "JZLocationConverter.h"

@interface ZHLocation () <CLLocationManagerDelegate>
@property (nonatomic, strong) ZHLocationModel *location;
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, copy) locationSuccessHandler successHandler;
@property (nonatomic, copy) locationFailureHandler failureHandler;
@property (nonatomic, assign) CLLocationCoordinate2D lastLocation;
@end

@implementation ZHLocation

static id _instace = nil;

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super init];
        self.lastLocation = CLLocationCoordinate2DMake(0, 0);
    });
    return _instace;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    if (_instace == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instace = [super allocWithZone:zone];
        });
    }
    return _instace;
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return _instace;
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instace;
}

#pragma mark - 定位失败

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"定位失败 !!");
#endif
    if (self.failureHandler){
        self.failureHandler(error);
    } else {
        if ([self.delegate respondsToSelector:@selector(locationdidFailWithError:)]) {
            [self.delegate locationdidFailWithError:error];
        }
    }
}

#pragma mark - Public

- (void)beginUpdatingLocation{
    if ([self.locationManager respondsToSelector:@selector(startUpdatingLocation)]) {
        [self.locationManager startUpdatingLocation];
    }
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
}

/// 初始化开始定位并且block回调
- (void)beginUpdatingLocationSuccess:(locationSuccessHandler)success
                             failure:(locationFailureHandler)failure{
    [self beginUpdatingLocation];
    self.successHandler = success;
    self.failureHandler = failure;
}

- (void)requetModifySystemForPermissions{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
        [app openURL:settingsURL options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (BOOL)locationServicesEnabled{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];  //是否开启定位服务
    if (!isLocation) {
        return NO;
    } else {
        CLAuthorizationStatus locationStatus = [CLLocationManager authorizationStatus];
        switch (locationStatus) {
            case kCLAuthorizationStatusNotDetermined: return NO; break; // 未询问用户是否授权
            case kCLAuthorizationStatusRestricted:  return NO;  break;  // 未授权，例如家长控制
            case kCLAuthorizationStatusDenied:  return NO;  break;      // 未授权，用户拒绝造成的
            case kCLAuthorizationStatusAuthorizedAlways: return YES; break;     // 同意授权一直获取定位信息
            case kCLAuthorizationStatusAuthorizedWhenInUse: return YES; break;  // 同意授权在使用时获取定位信息
            default: return NO; break;
        }
    }
}


#pragma mark - 定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = locations.lastObject;
    
    if (currentLocation.coordinate.latitude != self.lastLocation.latitude ||
        currentLocation.coordinate.longitude != self.lastLocation.longitude) {
        self.lastLocation = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
        //同一个位置,仅回调一次
        __weak typeof(self) ws = self;
        [self reverseGeocodeLocationWithLocation:currentLocation handler:^(ZHLocationModel *locationObj) {
            ws.location = locationObj;
            if (ws.successHandler){
                ws.successHandler(ws.location);
            } else{
                if ([ws.delegate respondsToSelector:@selector(locationDidEndUpdatingLocation:)]){
                    [ws.delegate locationDidEndUpdatingLocation:ws.location];
                }
            }
        }];
    }else{
        NSLog(@"更新了上一个位置");
    }
    [manager stopUpdatingLocation];
}

/// 根据经纬度反向地理编译出地址信息
- (void)reverseGeocodeLocationWithLocation:(CLLocation *)location handler:(locationSuccessHandler)handler{
    //根据经纬度反向地理编译出地址信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error){
        if (placemarks.count > 0){
            ZHLocationModel *locaitonObj = [[ZHLocationModel alloc]init];
            CLPlacemark *placemark = placemarks.firstObject;
            
            locaitonObj.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
            locaitonObj.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
            
            CLLocationCoordinate2D gcsLocation = [JZLocationConverter wgs84ToGcj02:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
            locaitonObj.longitude_GCJ02 = [NSString stringWithFormat:@"%f",gcsLocation.longitude];
            locaitonObj.latitude_GCJ02 = [NSString stringWithFormat:@"%f",gcsLocation.latitude];
            
            CLLocationCoordinate2D gcsLocation2 = [JZLocationConverter wgs84ToBd09:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
            locaitonObj.longitude_Bd09 = [NSString stringWithFormat:@"%f",gcsLocation2.longitude];
            locaitonObj.latitude_Bd09 = [NSString stringWithFormat:@"%f",gcsLocation2.latitude];
            
            locaitonObj.name = placemark.name;
            locaitonObj.thoroughfare = placemark.thoroughfare;
            locaitonObj.subThoroughfare = placemark.subThoroughfare;
            locaitonObj.locality = !placemark.locality ? placemark.administrativeArea : placemark.locality;
            locaitonObj.subLocality = placemark.subLocality;
            locaitonObj.administrativeArea = placemark.administrativeArea;
            locaitonObj.postalCode = placemark.postalCode;
            locaitonObj.ISOcountryCode = placemark.ISOcountryCode;
            locaitonObj.country = placemark.country;
            locaitonObj.inlandWater = placemark.inlandWater;
            locaitonObj.ocean = placemark.ocean;
            
            //country administrativeArea locality subLocality thoroughfare name
            locaitonObj.locationDescription = locaitonObj.administrativeArea?:@"";
            locaitonObj.locationDescription = [locaitonObj.locationDescription stringByAppendingString:locaitonObj.locality?:@""];
            locaitonObj.locationDescription = [locaitonObj.locationDescription stringByAppendingString:locaitonObj.subLocality?:@""];
            locaitonObj.locationDescription = [locaitonObj.locationDescription stringByAppendingString:locaitonObj.thoroughfare?:@""];
            if (![locaitonObj.thoroughfare isEqualToString:locaitonObj.name]) {
                locaitonObj.locationDescription = [locaitonObj.locationDescription stringByAppendingString:locaitonObj.name?:@""];
            }
            if (handler){
                handler(locaitonObj);
            }
        }
    }];
}

#pragma mark - setter and getter

- (ZHLocationModel *)locationObj{
    return self.location;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyKilometer;
    }
    return _locationManager;
}

- (ZHLocationModel *)location{
    if(!_location){
        _location = [[ZHLocationModel alloc]init];
    }
    return _location;
}
@end


@implementation ZHLocationModel

@end
