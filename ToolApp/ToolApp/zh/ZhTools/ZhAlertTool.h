//
//  ZhAlertTool.h
//  Consultant
//
//  Created by 张志华 on 9/15/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

typedef void (^SelectBlock)(NSInteger selectIndex, NSString * _Nullable selectStr);
typedef void (^SelectStrBlock)(NSString * _Nullable selectStr);

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhAlertTool : NSObject

#pragma mark ====== AlertView ======

/// 提示标题 自定义确定按钮
+ (void)showAlertWithTitle:(NSString *)title sure:(nullable NSString *)sure;

/// 提示标题  内容(可选)  取消文字(可选)   确认文字(可选,有默认)  取消回调(可选)  确认回调
+ (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel sure:(nullable NSString *)sure cancelBlock:(nullable void(^)(void))cancelBlock sureBlock:(nullable void(^)(void))sureBlock;


#pragma mark ====== ActionSheet ======

/// 微信底部弹框选择
/// @param options 选项
/// @param cancelStr 取消文字 (可选,有默认)
/// @param title 标题 (可选)
/// @param callBack 回调数据
+ (void)alerWithOptions:(NSArray *)options cancelStr:(nullable NSString *)cancelStr sectionTitle:(nullable NSString *)title select:(SelectBlock)callBack;

#pragma mark ====== PickerView ======

/// 弹出pickerView单项选择
+ (void)showPickerWithOptions:(NSArray *)options sectionTitle:(nullable NSString *)title select:(SelectBlock)callBack;


#pragma mark ====== Area ======

/// 弹出选择地址的选择
+ (void)showPickerAreaWithSelect:(SelectStrBlock)callBack;


#pragma mark ====== Time ======

/// 选择年月日日期
+ (void)showDateTimeByYMD:(SelectStrBlock)callBack;

/// 选择年月日期
+ (void)showDateTimeByYM:(SelectStrBlock)callBack;

/// 选择年月日期,记录上次的日期
+ (void)showDateWithLastDate:(nullable NSString *)lastDate TimeByYM:(SelectStrBlock)callBack;


@end

NS_ASSUME_NONNULL_END
