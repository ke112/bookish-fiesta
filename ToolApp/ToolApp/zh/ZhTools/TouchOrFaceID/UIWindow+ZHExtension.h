//
//  UIWindow+ZHExtension.h
//  ToucheIDORFaceID
//
//  Created by zhangzhihua-imac on 2019/11/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

/**
 UIWindow hierarchy category.
 代码从IQKeyboardManager复制
 category名称修改，以防用到IQKeyboardManager的冲突
 */

@interface UIWindow (ZHExtension)

///----------------------
/// @name viewControllers
///----------------------

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *topMostController;

/**
 Returns the topViewController in stack of topMostController.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *currentViewController;


@end

NS_ASSUME_NONNULL_END
