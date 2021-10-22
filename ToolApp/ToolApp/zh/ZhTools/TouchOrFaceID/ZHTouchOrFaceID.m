//
//  ZHTouchOrFaceID.m
//  ToucheIDORFaceID
//
//  Created by zhangzhihua-imac on 2019/11/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "ZHTouchOrFaceID.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "ZHAlertAction.h"

static NSString * const constTips            = @"Tips";          //温馨提示
static NSString * const constSure            = @"OK";            //确定

static NSString * const constFingerVerify    = @"Verify existing phone fingerprints with the Home button"; //通过Home键验证已有手机指纹
static NSString * const constFaceVerify      = @"Verify existing phone faces"; //验证已有手机面容

static NSString * const constCloseFinger     = @"Fingerprint login is closed"; //指纹登录关闭
static NSString * const constCloseFace       = @"Face login closed"; //面容登录关闭

static NSString * const constNotSet          = @"Your device does not have a lock screen password set"; //您的设备未设置锁屏密码

static NSString * const constNotEnrolledFinger   = @"Your device is not enrolled in fingerprints"; //您的设备未录入指纹
static NSString * const constNotEnrolledFace     = @"Your device is not recorded"; //您的设备未录入面容

static NSString * const constFailedFinger    = @"Fingerprint verification failed, please enter valid fingerprint information"; //指纹验证失败，请录入有效的指纹信息
static NSString * const constFailedFace      = @"Face verification failed, please enter valid face information"; //面容验证失败，请录入有效的面容信息

static NSString * const constNotAvailableFinger  = @"Fingerprint information is not available on the device"; //指纹信息在设备上不可用
static NSString * const constNotAvailableFace    = @"Face information is not available on the device"; //面容信息在设备上不可用

static NSString * const constLockoutFinger   = @"Fingerprint verification failed too many times, fingerprint verification has been locked, please enter the password in iPhone - Settings - Touch ID and password to unlock the fingerprint verification"; //指纹验证失败次数过多，指纹验证已锁定，请在iPhone手机－设置－Touch ID与密码中输入密码，即可解锁指纹验证
static NSString * const constLockoutFace     = @"Face verification failed too many times, face verification is locked, please enter the password in iPhone - Settings - Face ID and password to unlock face verification"; //面容验证失败次数过多，面容验证已锁定，请在iPhone手机－设置－Face ID与密码中输入密码，即可解锁面容验证

static NSString * const constFinalFailedFinger   = @"Fingerprint verification failed"; //指纹验证失败
static NSString * const constFinalFailedFace     = @"Face verification failed"; //面容验证失败


@implementation ZHTouchOrFaceID

/// 单例
+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
/// 设备是否有指纹功能
+ (BOOL)isHasTouchID{
    // 先判断系统级别iOS8  再判断设备是否支持64位
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        return NO;
    }
    else{
#if defined(__LP64__) && __LP64__
        return YES;
#else
        return NO;
#endif
    }
}

#pragma mark 指纹识别登录
- (void)touchIDLoginReply:(TouchIDAuth)TouchIDAuthBlock{
    NSError * authError = nil;
    NSString * reasionStr = constFingerVerify;
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    if ([context respondsToSelector:@selector(maxBiometryFailures)]) {
        // 最大验证失败次数
//        context.maxBiometryFailures = [NSNumber numberWithInteger:5];
    }
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
#if  1
        if (@available(iOS 11.0, *)) {
            if (context.biometryType == LABiometryTypeFaceID) {
                reasionStr = constFaceVerify;
            }
        }
#endif
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reasionStr reply:^(BOOL success, NSError *error) {
//            NSLog(@"errorCode = %lD",(long)[error code]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    if (TouchIDAuthBlock) {
                        TouchIDAuthBlock(ZHTouchIDAuthSucess);
                    }
                } else {
                    if (error.code == LAErrorAuthenticationFailed) {
                        if (TouchIDAuthBlock) {
                            TouchIDAuthBlock(ZHTouchIDAuthFail);
                        }
                    } else if (error.code == LAErrorUserCancel){
                        if (TouchIDAuthBlock) {
                            TouchIDAuthBlock(ZHTouchIDAuthCancle);
                        }
                    } else {
                        if (TouchIDAuthBlock) {
                            TouchIDAuthBlock(ZHTouchIDAuthOther);
                        }
                    }
                }
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (TouchIDAuthBlock) {
                TouchIDAuthBlock(ZHTouchIDAuthOther);
            }
#if  1
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeFaceID) {
                    [self alertWithFaceIDError:authError];
                } else {
                    [self alertWithError:authError];
                }
            } else {
                [self alertWithError:authError];
            }
#else
            [self alertWithError:authError];
#endif
        });
    }
}

/// 开启指纹识别
- (void)openEvaluatePolicyreply:(TouchIDOpen)touchIDOpenBlock{
    [self handleEvaluatePolicyreply:touchIDOpenBlock open:YES];
}

/// 关闭指纹识别
- (void)closeEvaluatePolicyreply:(TouchIDOpen)touchIDCloseBlock{
    [self handleEvaluatePolicyreply:touchIDCloseBlock open:NO];
}

/// 统一处理开启或关闭设备验证
/// @param touchIDBlock 回调结果
/// @param isopen 是开启
- (void)handleEvaluatePolicyreply:(TouchIDOpen)touchIDBlock open:(BOOL)isopen{
    NSError * authError = nil;
    NSString * reasionStr = (isopen == YES ? constFingerVerify : constCloseFinger);
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    if ([context respondsToSelector:@selector(maxBiometryFailures)]) {
        // 最大验证失败次数
//        context.maxBiometryFailures = [NSNumber numberWithInteger:5];
    }
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&authError]) {
#if  1
        if (@available(iOS 11.0, *)) {
            if (context.biometryType == LABiometryTypeFaceID) {
                reasionStr = (isopen == YES ? constFaceVerify : constCloseFace);
            }
        }
#endif
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:reasionStr reply:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    
                }
                else{
                    
                }
                if (touchIDBlock) {
                    touchIDBlock(success);
                }
            });
        }];
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (touchIDBlock) {
                touchIDBlock(NO);
            }
#if  1
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeFaceID) {
                    [self alertWithFaceIDError:authError];
                }
                else{
                    [self alertWithError:authError];
                }
            }
            else{
                [self alertWithError:authError];
            }
#else
            [self alertWithError:authError];
#endif
        });
    }
}


#pragma mark 弹出错误信息（默认指纹）
- (void)alertWithError:(NSError *)authError{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([authError code] == LAErrorPasscodeNotSet) {
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotSet buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if([authError code] == LAErrorTouchIDNotEnrolled){
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotEnrolledFinger buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorAuthenticationFailed){
            [ZHAlertAction showAlertWithTitle:constTips msg:constFailedFinger buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorTouchIDNotAvailable){
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotAvailableFinger buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorTouchIDLockout){
            [ZHAlertAction showAlertWithTitle:constTips msg:constLockoutFinger buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else{
            [ZHAlertAction showAlertWithTitle:constTips msg:constFinalFailedFinger buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        }
    });
}

#pragma mark 弹出面容错误信息
- (void)alertWithFaceIDError:(NSError *)authError{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([authError code] == LAErrorPasscodeNotSet) {
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotSet buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if([authError code] == LAErrorTouchIDNotEnrolled){
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotEnrolledFace buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorAuthenticationFailed){
            [ZHAlertAction showAlertWithTitle:constTips msg:constFailedFace buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorTouchIDNotAvailable){
            [ZHAlertAction showAlertWithTitle:constTips msg:constNotAvailableFace buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else if ([authError code] == LAErrorTouchIDLockout){
            [ZHAlertAction showAlertWithTitle:constTips msg:constLockoutFace buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        } else{
            [ZHAlertAction showAlertWithTitle:constTips msg:constFinalFailedFace buttonsStatement:@[constSure] chooseBlock:^(NSInteger buttonIdx) {
            }];
        }
    });
}


@end
