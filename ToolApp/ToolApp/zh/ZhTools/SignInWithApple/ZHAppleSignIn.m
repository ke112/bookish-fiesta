//
//  SignInWithAppleTool.m
//  SignInWithApple
//
//  Created by zhangzhihua-imac on 2019/11/19.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

/**
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonStyle) {//按钮的风格
     ASAuthorizationAppleIDButtonStyleWhite,   //白色的背景，黑色的文字和图标
     ASAuthorizationAppleIDButtonStyleWhiteOutline, //带有褐色的边框、黑色额字体和图标，白色的背景
     ASAuthorizationAppleIDButtonStyleBlack,//黑色的背景，白色的文字和图标
 }
 */

/**
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonType) {//按钮上文字的i显示
     ASAuthorizationAppleIDButtonTypeSignIn, // Sign in with Apple （通过Apple登录）
     ASAuthorizationAppleIDButtonTypeContinue, // Continue with Apple（通过Apple继续）
     ASAuthorizationAppleIDButtonTypeDefault = ASAuthorizationAppleIDButtonTypeSignIn,
 }
 */

#import "ZHAppleSignIn.h"

@interface ZHAppleSignIn ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ZHAppleSignIn

+ (instancetype)manager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 可以添加苹果登录按钮
+ (BOOL)isCanAdd{
    if (@available(iOS 13.0, *)) {
        return YES;
    }
    return NO;
}
/// 添加苹果登录按钮
- (ASAuthorizationAppleIDButton *)addSignIn{
    if (@available(iOS 13.0, *)) {//13.0的新属性
         ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
         appleIDButton.frame = CGRectMake(0, 0, 200, 50);
         [appleIDButton addTarget:self action:@selector(userAppIDLogin:) forControlEvents:UIControlEventTouchUpInside];
        return appleIDButton;
    }
    return nil;
}

#pragma mark - 处理授权
- (void)userAppIDLogin:(ASAuthorizationAppleIDButton *)button  API_AVAILABLE(ios(13.0)) {
    [self showAppleLogin];
}
/// 弹起苹果登录
- (void)showAppleLogin{
    if (@available(iOS 13.0, *)) {
             // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            // 创建新的AppleID 授权请求
            ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
             // 在用户授权期间请求的联系信息
            request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
            
             //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
    //        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
    //        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
            
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
             // 设置授权控制器通知授权请求的成功与失败的代理
            controller.delegate = self;
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            controller.presentationContextProvider = self;
             // 在控制器初始化期间启动授权流
            [controller performRequests];
        } else {
            NSLog(@"系统不支持添加 Apple Login");
        }
}
#pragma mark - 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        if (self.resultSuccessBlock) {
            AppleSuccessModel *model = [[AppleSuccessModel alloc]init];
            model.givenName = credential.fullName.givenName;
            model.familyName = credential.fullName.familyName;
            model.user = credential.user;
            model.email = credential.email;
            model.identityToken = credential.identityToken;
            model.authorizationCodeData = credential.authorizationCode;
            model.authorizationCodeString = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
            self.resultSuccessBlock(model);
        }
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        NSLog(@"psduser -  %@   %@",psd,user);
    } else {
        NSLog(@"授权信息不符");
    }
}

#pragma mark - 授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    if (self.resultFailureBlock) {
        self.resultFailureBlock(error.code);
    }
//    NSString *errorMsg;
//    switch (error.code) {
//        case ASAuthorizationErrorCanceled:
//            errorMsg = @"用户取消了授权请求";
//            NSLog(@"errorMsg -   %@",errorMsg);
//            break;
//
//        case ASAuthorizationErrorFailed:
//            errorMsg = @"授权请求失败";
//            NSLog(@"errorMsg -   %@",errorMsg);
//            break;
//
//        case ASAuthorizationErrorInvalidResponse:
//            errorMsg = @"授权请求响应无效";
//            NSLog(@"errorMsg -   %@",errorMsg);
//            break;
//
//        case ASAuthorizationErrorNotHandled:
//            errorMsg = @"未能处理授权请求";
//            NSLog(@"errorMsg -   %@",errorMsg);
//            break;
//
//        case ASAuthorizationErrorUnknown:
//            errorMsg = @"授权请求失败未知原因";
//            NSLog(@"errorMsg -   %@",errorMsg);
//            break;
//
//        default:
//            break;
//    }
}


/// 监听登录授权状态的改变
- (void)monitorSignInWithAppleStateChanged:(NSNotification *)notification {
    NSLog(@"apple login 状态改变  - %@",notification);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller {
    return nil;
}




@end
