//
//  ZhAppTool.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/11/23.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZhAppTool : NSObject

/// 窗口主视图
+ (UIWindow *)keyWindow;

/// appDelegate
+ (AppDelegate *)appDelegate;

@end

NS_ASSUME_NONNULL_END
