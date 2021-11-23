//
//  UIViewController+ZhAlert.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/11/23.
//

#import "UIViewController+ZhAlert.h"

@implementation UIViewController (ZhAlert)

#pragma mark ====== AlertView ======

- (void)showAlertWithTitle:(NSString *)title doneTitle:(nullable NSString *)doneTitle doneClick:(nullable void(^)(void))doneClickBlock{
    [self showAlertWithTitle:title message:nil doneTitle:doneTitle sureBlock:doneClickBlock cancelTitle:nil cancelBlock:nil];
}
- (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message doneTitle:(nullable NSString *)doneTitle sureBlock:(nullable void(^)(void))doneBlock cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(nullable void(^)(void))cancelBlock{

    NSMutableArray *button = [NSMutableArray array];
    if (cancelTitle != nil) {
        [button addObject:cancelTitle];
        [button addObject:doneTitle];
    } else {
        [button addObject:doneTitle];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int index = 0; index < button.count; index++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:button[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (index == 0) {
                if (cancelBlock) {
                    cancelBlock();
                }
            } else {
                if (doneBlock) {
                    doneBlock();
                }
            }
        }];
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
