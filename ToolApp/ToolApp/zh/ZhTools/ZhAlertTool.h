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
+ (void)showAlertWithTitle:(NSString *)title doneTitle:(nullable NSString *)doneTitle doneClick:(nullable void(^)(void))doneClickBlock;

/// 提示标题  内容(可选)  取消文字(可选)   确认文字(可选,有默认)  取消回调(可选)  确认回调
+ (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message doneTitle:(nullable NSString *)doneTitle sureBlock:(nullable void(^)(void))doneBlock cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(nullable void(^)(void))cancelBlock;

#pragma mark ====== PickerView ======

/// 弹出pickerView单项选择
+ (void)showPickerWithOptions:(NSArray *)options sectionTitle:(nullable NSString *)title lastSel:(NSString *)lastSel select:(SelectBlock)callBack;


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
