//
//  AppleSuccessModel.h
//  SignInWithApple
//
//  Created by zhangzhihua-imac on 2019/11/19.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  apple sign in 登录成功的模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppleSuccessModel : NSObject
///志华
@property (nonatomic, copy) NSString *givenName;
///张
@property (nonatomic, copy) NSString *familyName;
///唯一标识 eg: 001225.5079fb81e18040808de9e01a4dfc991b.0139
@property (nonatomic, copy) NSString *user;
///邮箱 eg: zhangzhihua_fighting@icloud.com
@property (nonatomic, copy) NSString *email;
///JSON Web令牌（JWT），用于以安全方式将有关用户身份的信息传达给应用。 ID令牌将包含以下信息：由Apple身份服务签名的发行者标识符，主题标识符，受众，有效期和发行时间。
@property (nonatomic, strong) NSData *identityToken;

///说白了就是：给后台向苹果服务器验证使用，这个有时效性 五分钟之内有效
///data 数据
@property (nonatomic, strong) NSData *authorizationCodeData;
/// string 字符串
@property (nonatomic, copy) NSString *authorizationCodeString;
///真实值的状态 
@property (nonatomic, assign) NSInteger realUserStatus;


@end

NS_ASSUME_NONNULL_END
