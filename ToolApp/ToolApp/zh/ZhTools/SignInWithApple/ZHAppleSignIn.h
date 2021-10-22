//
//  AppleSignIn.h
//  SignInWithApple
//
//  Created by zhangzhihua-imac on 2019/11/19.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <objc/runtime.h>
#import "AppleSuccessModel.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))
@interface ZHAppleSignIn : NSObject

+ (instancetype)manager;

/// 是否可以添加苹果登录按钮
+ (BOOL)isCanAdd;

/// 添加苹果登录按钮 (需要设置frame)   // 宽高200 50 较合适
- (ASAuthorizationAppleIDButton *)addSignIn;

/// 弹起苹果登录(自定义按钮时使用)
- (void)showAppleLogin;

/// 登录成功 获取个人信息
@property (nonatomic, copy) void (^resultSuccessBlock)(AppleSuccessModel *userModel);

/// 登录失败 错误类型
@property (nonatomic, copy) void (^resultFailureBlock)(ASAuthorizationError type);


@end

NS_ASSUME_NONNULL_END
