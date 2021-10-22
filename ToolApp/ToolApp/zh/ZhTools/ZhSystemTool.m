//
//  SystemEventTool.m
//  WeDriveCoach
//
//  Created by 张志华 on 2019/6/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "ZhSystemTool.h"
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <Photos/Photos.h>
#import <MapKit/MapKit.h>
#import "UIDevice+ZhExt.h"
//震动
#import <AudioToolbox/AudioToolbox.h>
//钥匙串
#import <Security/Security.h>
//内置AppStore
#import <StoreKit/StoreKit.h>

@interface ZhSystemTool ()<MFMailComposeViewControllerDelegate,CLLocationManagerDelegate,SKStoreProductViewControllerDelegate>
{
    UIViewController *presentVc;
}

@property (strong, nonatomic) CLLocationManager *locationManager; //定位
@property (nonatomic, copy) void (^locationBlock)(NSString *lng,NSString *lat);

@end

@implementation ZhSystemTool

+ (instancetype)shared
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 打开链接
+ (BOOL)openURL:(NSString *)openUrl{
    __block BOOL isOpen = NO;
    NSURL *url= [NSURL URLWithString:openUrl];
    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            isOpen = success;
        }];
    }
    return isOpen;
}

/// 能否打开链接
+ (BOOL)canOpenURL:(NSString *)openUrl{
    __block BOOL isOpen = NO;
    NSURL *url= [NSURL URLWithString:openUrl];
    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
        return YES;
    }
    return isOpen;
}

/// 打开App Store下载页(app外部)
+ (BOOL)openAppStoreDownloadPage:(NSInteger)appID{
    NSString *urlStr = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%ld?mt=8",(long)appID];
    return [self openURL:urlStr];
}

/// 打开App Store下载页(app内部)
+ (void)openAppStoreDownloadPageInApp:(NSInteger)appID{
    [[ZhSystemTool new] openAppStoreDownloadPageInApp:appID];
}
- (void)openAppStoreDownloadPageInApp:(NSInteger)appID{
    if (@available(iOS 13,*)) {
        NSDictionary *appParameters = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",appID] forKey:SKStoreProductParameterITunesItemIdentifier];
        SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
        [productViewController setDelegate:self];
        [productViewController loadProductWithParameters:appParameters completionBlock:^(BOOL result, NSError * _Nullable error) {
            NSLog(@"打开App Store下载页(app内部) :   %d  %ld  %@",result,error.code,error.description);
            if (result == YES) {
                
            }else{
                [ZhSystemTool openAppStoreDownloadPage:appID];
                [productViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [[UIDevice zh_currentVc] presentViewController:productViewController animated:YES completion:^{
            NSLog(@"打开App Store下载页(app内部)   跳转完成");
        }];
    }else{
        [ZhSystemTool openAppStoreDownloadPage:appID];
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    NSLog(@"打开App Store下载页(app内部)  在代理方法里dismiss这个VC");
    //在代理方法里dismiss这个VC
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

/// 打开App Store评论页(app外部)
+ (BOOL)openAppStoreReviewsPage:(NSInteger)appID{
//    NSString *urlStr = [NSString stringWithFormat: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%ld&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",(long)appID];
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%ld?action=write-review", (long)appID];
    return [ZhSystemTool openURL:urlStr];
}

/// 打电话
+ (BOOL)callPhone:(NSString *)phone{
    NSString * telStr = [NSString stringWithFormat:@"tel:%@",phone];
    return [ZhSystemTool openURL:telStr];
}

/// 打开App 隐私设置
+ (BOOL)openAppPrivacySettings{
    return [ZhSystemTool openURL:UIApplicationOpenSettingsURLString];
}

/// 发邮件
+ (BOOL)sendEmail:(NSString *)email {
    return [ZhSystemTool openURL:[NSString stringWithFormat:@"mailto://%@",email]];
    
    //    if ([MFMailComposeViewController canSendMail]) {
    //        // 调用发送邮件的代码
    //
    //        // 创建邮件发送界面
    //        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    //        mailCompose.navigationBar.hidden = YES;
    //        // 设置邮件代理
    ////        [mailCompose setMailComposeDelegate:self];
    //        // 设置收件人
    //        [mailCompose setToRecipients:@[email]];
    //        //        // 设置抄送人
    //        //        [mailCompose setCcRecipients:@[@"1622849369@qq.com"]];
    //        //        // 设置密送人
    //        //        [mailCompose setBccRecipients:@[@"15690725786@163.com"]];
    //        // 设置邮件主题
    ////        [mailCompose setSubject:@"设置邮件主题"];
    //        //设置邮件的正文内容
    ////        NSString *emailContent = @"我是邮件内容";
    //        // 是否为HTML格式
    ////        [mailCompose setMessageBody:emailContent isHTML:NO];
    //        // 如使用HTML格式，则为以下代码
    //        // [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    //        //添加附件
    //        //    UIImage *image = [UIImage imageNamed:@"qq"];
    //        //    NSData *imageData = UIImagePNGRepresentation(image);
    //        //    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"qq.png"];
    //        //
    //        //    NSString *file = [[NSBundle mainBundle] pathForResource:@"EmptyPDF" ofType:@"pdf"];
    //        //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //        //    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"EmptyPDF.pdf"];
    //
    ////        AppDelegate *APP = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ////        [APP.window.navigationController presentViewController:mailCompose animated:YES completion:nil];
    //
    //        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mailCompose animated:YES completion:nil];
    //
    ////        UIViewController *objVC = [[APP.nav viewControllers]lastObject];
    ////        [objVC presentViewController:mc animated:YES completion:nil];
    //        // 弹出邮件发送视图
    ////        presentVc = [UIDevice currentVc];
    ////        [[UIDevice currentVc] presentViewController:mailCompose animated:YES completion:nil];
    //    }else{
    //        //给出提示,设备未开启邮件服务
    //        NSLog(@"不能发送邮件");
    //    }
    
    //创建可变的地址字符串对象：
    //    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //    //添加收件人：
    //    NSArray *toRecipients = @[email];
    //    // 注意：如有多个收件人，可以使用componentsJoinedByString方法连接，连接符为@","
    //    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    //
    //    //添加邮件主题和邮件内容：
    //    [mailUrl appendString:@"&subject=my email"];
    //    [mailUrl appendString:@"&body=<b>Hello</b> World!"];
}

#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //    // 关闭邮件发送视图
    //    [presentVc dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    //    AppDelegate * APP = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    UIViewController *objVC = [[APP.nav viewControllers]lastObject];
    //    [objVC dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

/// 获得系统定位经纬度 @[@"lng",@"lat"]
- (void)getSystemLocationWithBlock:(void(^)(NSString *lng,NSString *lat))block{
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.locationBlock = ^(NSString *lng, NSString *lat) {
        block(lng,lat);
    };
}

#pragma mark CoreLocation deleagte (定位失败)
/*定位失败则执行此代理方法*/
/*定位失败弹出提示窗，点击打开定位按钮 按钮，会打开系统设置，提示打开定位服务*/
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    /*设置提示提示用户打开定位服务*/
    [ZhSystemTool showLocationError];
}
/*定位成功后则执行此代理方法*/
#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    /*旧值*/
    CLLocation * currentLocation = [locations lastObject];
    /*打印当前经纬度*/
//    NSLog(@"经度:%f  纬度:%f",currentLocation.coordinate.longitude,currentLocation.coordinate.latitude);
    if (self.locationBlock) {
        self.locationBlock([NSString stringWithFormat:@"%.6f",currentLocation.coordinate.longitude], [NSString stringWithFormat:@"%.6f",currentLocation.coordinate.latitude]);
    }
}

/// 定位失败的提示框
+ (void)showLocationError{
//    NSString *title = [NSString stringWithFormat:@"请允许 \"%@\" 获取您的位置权限 ?",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
}


- (CLLocationManager *)locationManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

/// APP震动
+ (void)shock{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - UINotificationFeedbackGenerator

+ (void)shockSuccessFeedback
{
    if (@available(iOS 10.0, *)) {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)shockWarningFeedback
{
    if (@available(iOS 10.0, *)) {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator notificationOccurred:UINotificationFeedbackTypeWarning];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)shockErrorFeedback
{
    if (@available(iOS 10.0, *)) {
        UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
        [generator notificationOccurred:UINotificationFeedbackTypeError];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - UIImpactFeedbackGenerator

+ (void)shockLightFeedback
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)shockMediumFeedback
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)shockHeavyFeedback
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleHeavy];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

+ (void)shockSoftFeedback{
    if (@available(iOS 13.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleSoft];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}
+ (void)shockRigidFeedback{
    if (@available(iOS 13.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleRigid];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}
#pragma mark - UISelectionFeedbackGenerator

+ (void)shockSelectionFeedback
{
    if (@available(iOS 10.0, *)) {
        UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
        [generator selectionChanged];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark --- 钥匙串相关方法
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)saveKeyChain:(NSString *)key data:(id)data{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)getKeyChain:(NSString *)key{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            //            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyChain:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}


/// 切换扬声器
/// @param isYang 是否打开扬声器
+ (BOOL)turnOnTheSpeaker:(BOOL)isYang{
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL result = NO;
//    if (isYang) {
//        result = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//        NSLog(@"打开扬声器 %@",result?@"成功":@"失败");
//    } else {
//        result = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//        NSLog(@"关闭扬声器 %@",result?@"成功":@"失败");
//    }
//    [audioSession setActive:YES error:nil];
    return result;
}

/// 相册权限检测
+ (void)isCanVisitPhotoLibrary:(void(^)(BOOL))result{
    
    PHAuthorizationStatus status1 = [PHPhotoLibrary authorizationStatus];
    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ///用户已授权此应用程序有限的照片库访问权限
                if (status == PHAuthorizationStatusLimited) {
                    result(NO);
                    return;
                }
                if (status == PHAuthorizationStatusAuthorized) {
                    result(YES);
                    return;
                }
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    result(NO);
                    return;
                }
                
                if (status == PHAuthorizationStatusNotDetermined) {
                    
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        // 回调是在子线程的
                        NSLog(@"%@",[NSThread currentThread]);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (status != PHAuthorizationStatusAuthorized) {
                                  result(NO);
                                  return;
                            }
                            result(YES);
                        });
              
                    }];
                }
            });
        }];
    }else{
        if (status1 == PHAuthorizationStatusAuthorized) {
            result(YES);
            return;
        }
        if (status1 == PHAuthorizationStatusRestricted || status1 == PHAuthorizationStatusDenied) {
            result(NO);
            return;
        }
        
        if (status1 == PHAuthorizationStatusNotDetermined) {
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                // 回调是在子线程的
                NSLog(@"%@",[NSThread currentThread]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status != PHAuthorizationStatusAuthorized) {
                          result(NO);
                          return;
                    }
                    result(YES);
                });
      
            }];
        }
    }
}


@end
