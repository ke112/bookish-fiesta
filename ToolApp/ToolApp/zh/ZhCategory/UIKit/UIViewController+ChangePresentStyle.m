//
//  UIViewController+ChangePresentStyle.m
//  WeDriveCoach
//
//  Created by 张志华 on 2019/9/23.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "UIViewController+ChangePresentStyle.h"
#import <objc/runtime.h>

@implementation UIViewController (ChangePresentStyle)

+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //替换方法
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(ci_presentViewController:animated:completion:);

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

- (void)ci_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self ci_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
