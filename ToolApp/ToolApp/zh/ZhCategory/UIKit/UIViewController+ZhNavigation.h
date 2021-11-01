//
//  UIViewController+ZhNavigation.h
//  Consultant
//
//  Created by 张志华 on 9/9/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZhNavigation)

#pragma mark ====== find ======
/// 从导航控制器栈中查找ViewController，没有时返回nil
- (UIViewController *)zh_findViewController:(NSString *)className;

/// viewController是否是push方式显示的,反之为present
- (BOOL)zh_PushedShow;

#pragma mark ====== delete ======
/// 删除指定的视图控制器
- (void)zh_deleteClass:(NSArray *)classNames complete:(nullable void(^)(void))complete;

#pragma mark ====== push ======
/// 跳转到指定的视图控制器，此方法可防止循环跳转
- (void)zh_pushOnceClass:(UIViewController *)toClass animated:(BOOL)animated;

/// 返回到某个栈视图控制器,push下一个视图控制器
- (void)zh_pushFromClass:(NSString *)fromClass toClass:(UIViewController *)toClass animated:(BOOL)animated;

/// 向上返回视图控制器的层级,push下一个视图控制器
- (void)zh_pushUpCount:(NSInteger)count toClass:(UIViewController *)toClass animated:(BOOL)animated;

/// 返回到根视图控制器后count个层级,push下一个视图控制器
- (void)zh_pushFromRootCount:(NSInteger)count toClass:(UIViewController *)toClass animated:(BOOL)animated;

/// 返回到根视图控制器,push下一个视图控制器
- (void)zh_pushFromRootToClass:(UIViewController *)toClass animated:(BOOL)animated;

#pragma mark ====== pop ======
/// 返回到指定视图控制器
- (void)zh_popToClass:(NSString *)toClass animated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
