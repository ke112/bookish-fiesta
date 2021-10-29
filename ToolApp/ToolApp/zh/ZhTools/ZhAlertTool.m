//
//  ZhAlertTool.m
//  Consultant
//
//  Created by 张志华 on 9/15/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "ZhAlertTool.h"
#import <BRPickerView/BRPickerView.h>

@implementation ZhAlertTool

#pragma mark ====== AlertView ======

+ (void)showAlertWithTitle:(NSString *)title doneTitle:(nullable NSString *)doneTitle doneClick:(nullable void(^)(void))doneClickBlock{
    [ZhAlertTool showAlertWithTitle:title message:nil doneTitle:doneTitle sureBlock:doneClickBlock cancelTitle:nil cancelBlock:nil];
}
+ (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message doneTitle:(nullable NSString *)doneTitle sureBlock:(nullable void(^)(void))doneBlock cancelTitle:(nullable NSString *)cancelTitle cancelBlock:(nullable void(^)(void))cancelBlock{

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
    [[UIDevice zh_currentRootVc] presentViewController:alertController animated:YES completion:nil];
}

/// 获取设备当前window vc
+ (UIViewController *)zh_currentRootVc{
    UIViewController *result = nil;
    UIWindow * window = [self zh_currentkeyWindow];
    if ([window subviews].count > 0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }else{
            result = window.rootViewController;
        }
    }
    return result;
}
/// 获取当前keyWindow
+ (UIWindow *)zh_currentkeyWindow{
    if (@available(iOS 13.0, *)){
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive){
                for (UIWindow *window in windowScene.windows){
                    if (window.isKeyWindow){
                        return window;
                        break;
                    }
                }
            }
        }
    }else{
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

#pragma mark ====== PickerView ======

/// 弹出pickerView选择器
+ (void)showPickerWithOptions:(NSArray *)options sectionTitle:(nullable NSString *)title lastSel:(NSString *)lastSel select:(SelectBlock)callBack{
//    if (options.count==0) {
//        return;
//    }
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    
    BRPickerStyle *style = [[BRPickerStyle alloc]init];
    style.titleTextFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    style.doneTextFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    style.cancelTextFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    style.selectRowTextFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    style.pickerTextFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    
    if (@available(iOS 13.0, *)) {
        style.titleTextColor = UIColor.secondaryLabelColor;
        style.doneTextColor = UIColor.labelColor;
        style.cancelTextColor = UIColor.labelColor;
        style.selectRowTextColor = UIColor.labelColor;
        style.pickerTextColor = UIColor.secondaryLabelColor;
    }else{
        style.titleTextColor = UIColor.grayColor;
        style.doneTextColor = UIColor.blackColor;
        style.cancelTextColor = UIColor.blackColor;
        style.selectRowTextColor = UIColor.blackColor;
        style.pickerTextColor = UIColor.grayColor;
    }
    
    stringPickerView.pickerStyle = style;
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    if (title) {
        stringPickerView.title = title;
    }
    stringPickerView.dataSourceArr = options;
    if (lastSel) {
        stringPickerView.selectValue = lastSel;
    }
    stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
        if (callBack) {
            callBack(resultModel.index,resultModel.value);
        }
    };
    [stringPickerView show];
}

#pragma mark ====== Area ======
/// 弹出选择地址的选择
+ (void)showPickerAreaWithSelect:(SelectStrBlock)callBack{
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
    addressPickerView.pickerMode = BRAddressPickerModeArea;
    addressPickerView.title = @"请选择地址";
    // 传入自定义数据源
    addressPickerView.dataSourceArr = [self readLocalFileWithName:@"province"];
    addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        NSString *areaStr = [NSString stringWithFormat:@"%@-%@-%@", province.name, city.name, area.name];
        if (callBack) {
            callBack(areaStr);
        }
    };
    [addressPickerView show];
}

// 读取本地JSON文件
+ (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    KKLog(@"===== %@",dataArr);
    return dataArr;
}

#pragma mark ====== Time ======
/// 选择年月日日期
+ (void)showDateTimeByYMD:(SelectStrBlock)callBack{
    [self showDateTimeByFormatter:BRDatePickerModeYMD call:callBack];
}
/// 选择年月日期
+ (void)showDateTimeByYM:(SelectStrBlock)callBack{
    [self showDateTimeByFormatter:BRDatePickerModeYM call:callBack];
}
+ (void)showDateTimeByFormatter:(BRDatePickerMode)mode call:(SelectStrBlock)callBack{
    [self showDateTimeByFormatter:mode lastDate:nil call:callBack];
}
/// 选择年月日期,记录上次的日期
+ (void)showDateWithLastDate:(nullable NSString *)lastDate TimeByYM:(SelectStrBlock)callBack{
    [self showDateTimeByFormatter:BRDatePickerModeYM lastDate:lastDate call:callBack];
}
+ (void)showDateTimeByFormatter:(BRDatePickerMode)mode lastDate:(nullable NSString *)lastDate call:(SelectStrBlock)callBack{
    BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
    datePickerView.pickerMode = mode;
    datePickerView.title = @"选择日期";
    if (lastDate) {
        datePickerView.selectValue = lastDate;
    }
    datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
        if (callBack) {
            callBack(selectValue);
        }
    };
    
    // 设置年份背景
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, UIScreen.mainScreen.bounds.size.width, 216)];
    yearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
    yearLabel.font = [UIFont boldSystemFontOfSize:100.0f];
    
    NSString *yearString = @([NSDate date].br_year).stringValue;
    yearLabel.text = yearString;
    [datePickerView.alertView addSubview:yearLabel];
    // 滚动选择器，动态更新年份
    datePickerView.changeBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        yearLabel.text = selectDate ? @(selectDate.br_year).stringValue : @"";
    };
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.pickerColor = [UIColor clearColor];
    customStyle.selectRowTextColor = [UIColor blueColor];
    datePickerView.pickerStyle = customStyle;
    [datePickerView show];
}

@end
