//
//  UIViewController+ZhNavigation.m
//  Consultant
//
//  Created by 张志华 on 9/9/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "UIViewController+ZhNavigation.h"
#import <objc/runtime.h>

static char *naviAlphaKey = @"naviAlphaKey";

@implementation UIViewController (ZhNavigation)

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //替换方法
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(zh_presentViewController:animated:completion:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);;
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));

        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)zh_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    //设置默认的present模式为全屏
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self zh_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)setZh_naviAlpha:(NSString *)zh_naviAlpha{
    objc_setAssociatedObject(self, naviAlphaKey, zh_naviAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)zh_naviAlpha{
    NSString *naviAlpha = objc_getAssociatedObject(self, naviAlphaKey);
    return naviAlpha ? : @"1";
}

#pragma mark ====== find ======
/// 从导航控制器栈中查找ViewController，没有时返回nil
- (UIViewController *)zh_findViewController:(NSString *)className {
    if (className == nil || className.length == 0) { return nil;}
    Class class = NSClassFromString(className);
    if (class == nil) return nil;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if([controller isKindOfClass:class]) {
            return controller;
        }
    }
    return nil;
}

/// viewController是否是push方式显示的,反之为present
- (BOOL)zh_PushedShow {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    ZHDisplaMode displaMode = zh_DisplaModePush;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            displaMode = zh_DisplaModePush;
        }
    }else {
        //present方式
        displaMode = zh_DisplaModePresent;
    }
    return displaMode == zh_DisplaModePush;
}

/// 删除指定的视图控制器
- (void)zh_deleteClass:(NSArray *)classNames complete:(nullable void(^)(void))complete{
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:navArray];
    for (NSString *className in classNames) {
        if (className == nil || className.length == 0) {
            break;
        }
        [navArray enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                //栈顶保留
            } else {
                if ([vc isKindOfClass:NSClassFromString(className)]) {
                    [vcArr removeObject:vc];
                }
            }
        }];
    }
    self.navigationController.viewControllers = vcArr;
    if (complete) {
        complete();
    }
}

#pragma mark ====== push ======

/// 跳转到指定的视图控制器，此方法可防止循环跳转
- (void)zh_pushOnceClass:(UIViewController *)toClass animated:(BOOL)animated{
    if (toClass) {
        [self.navigationController pushViewController:toClass animated:animated];
    }else{
        return;
    }
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:navArray];
    [navArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == navArray.count-1) {
            //栈尾保留
        }else{
            //次栈尾判断不是本类就停止
            NSString *s1 = NSStringFromClass([vc class]);
            NSString *s2 = NSStringFromClass([toClass class]);
            if ([s1 isEqualToString:s2]) {
                [vcArr removeObject:vc];
            }else{
                *stop = YES;
            }
        }
    }];
    self.navigationController.viewControllers = vcArr;
}
/// 返回到某个栈视图控制器,push下一个视图控制器
- (void)zh_pushFromClass:(NSString *)fromClass toClass:(UIViewController *)toClass animated:(BOOL)animated{
    if (toClass) {
        [self.navigationController pushViewController:toClass animated:animated];
    }else{
        return;
    }
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:navArray];
    __block NSInteger index = 0;
    [navArray enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([vc isKindOfClass:NSClassFromString(fromClass)]){
            index = idx;
            *stop = YES;
        }
    }];
    [navArray enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == navArray.count-1) {
            //栈尾保留
        }else{
            if (idx > index) {
                [vcArr removeObject:vc];
            }
        }
    }];
    self.navigationController.viewControllers = vcArr;
}
/// 关闭向上视图控制器的层级,push下一个视图控制器
- (void)zh_pushUpCount:(NSInteger)count toClass:(UIViewController *)toClass animated:(BOOL)animated{
    if (toClass) {
        [self.navigationController pushViewController:toClass animated:animated];
    }else{
        return;
    }
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:navArray];
    [navArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == navArray.count-1) {
            //栈尾保留
        }else{
            if (idx >= navArray.count-1-count) {
                [vcArr removeObject:vc];
            }else{
                *stop = YES;
            }
        }
    }];
    self.navigationController.viewControllers = vcArr;
}
/// 返回到根向下视图控制器的层级,push下一个视图控制器
- (void)zh_pushFromRootCount:(NSInteger)count toClass:(UIViewController *)toClass animated:(BOOL)animated{
    if (toClass) {
        [self.navigationController pushViewController:toClass animated:animated];
    }else{
        return;
    }
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:navArray];
    [navArray enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == navArray.count-1) {
            //栈尾保留
        }else{
            //0是第一个
            if (idx > count) {
                [vcArr removeObject:vc];
            }
        }
    }];
    self.navigationController.viewControllers = vcArr;
}
/// 返回到根视图控制器,push下一个视图控制器
- (void)zh_pushFromRootToClass:(UIViewController *)toClass animated:(BOOL)animated{
    [self zh_pushFromRootCount:0 toClass:toClass animated:animated];
}

#pragma mark ====== pop ======
/// 返回到指定视图控制器
- (void)zh_popToClass:(NSString *)toClass animated:(BOOL)animated{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(toClass)]) {
            [self.navigationController popToViewController:vc animated:animated];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:animated];
}


@end
