//
//  UIViewController+ZhAlert.h
//  ToolApp
//
//  Created by zhangzhihua on 2021/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZhAlert)

#pragma mark ====== AlertView ======

/// 提示标题 自定义确定按钮
- (void)showAlertWithTitle:(NSString *)title doneTitle:(nullable NSString *)doneTitle doneClick:(nullable void(^)(void))doneClickBlock;

/// 提示标题  内容(可选)  取消文字(可选)   确认文字(可选,有默认)  取消回调(可选)  确认回调
- (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message doneTitle:(nullable NSString *)doneTitle sureBlock:(nullable void(^)(void))doneBlock cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(nullable void(^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
