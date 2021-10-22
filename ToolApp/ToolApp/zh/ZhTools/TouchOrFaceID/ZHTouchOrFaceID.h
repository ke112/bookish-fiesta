//
//  ZHTouchOrFaceID.h
//  ToucheIDORFaceID
//
//  Created by zhangzhihua-imac on 2019/11/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//  Face ID 需要再info.plist 中添加 NSFaceIDUsageDescription 的描述

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ZHTouchIDAuthSucess,
    ZHTouchIDAuthFail,
    ZHTouchIDAuthCancle,
    ZHTouchIDAuthOther,
    
} ZHTouchIDAuthResult;

typedef void(^TouchIDOpen)(BOOL isSucessed);
typedef void(^TouchIDAuth)(ZHTouchIDAuthResult result);

@interface ZHTouchOrFaceID : NSObject

/// 单例
+ (instancetype)manager;

/// 设备是否有指纹或面容功能
+ (BOOL)isHasTouchID;

/// 执行验证登录
- (void)touchIDLoginReply:(TouchIDAuth)TouchIDAuthBlock;

/// 开启指纹或面容识别
- (void)openEvaluatePolicyreply:(TouchIDOpen)touchIDOpenBlock;

/// 关闭指纹或面容识别
- (void)closeEvaluatePolicyreply:(TouchIDOpen)touchIDCloseBlock;

@end

NS_ASSUME_NONNULL_END
