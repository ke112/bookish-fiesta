//
//  ZhAlertTool.m
//  Consultant
//
//  Created by 张志华 on 9/15/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "ZhAlertTool.h"
#import "UIDevice+ZhExt.h"

#if __has_include(<LEEAlert/LEEAlert.h>)
#import <LEEAlert/LEEAlert.h>
#elif __has_include("LEEAlert")
#import "LEEAlert"
#endif

#if __has_include(<BRPickerView/BRPickerView.h>)
#import <BRPickerView/BRPickerView.h>
#elif __has_include("BRPickerView")
#import "BRPickerView"
#endif


@implementation ZhAlertTool


#pragma mark ====== AlertView ======

+ (void)showAlertWithTitle:(NSString *)title sure:(nullable NSString *)sure{
    [ZhAlertTool showAlertWithTitle:title message:nil cancel:nil sure:sure cancelBlock:nil sureBlock:nil];
}
+ (void)showAlertWithTitle:(NSString *)title message:(nullable NSString *)message cancel:(nullable NSString *)cancel sure:(nullable NSString *)sure cancelBlock:(nullable void(^)(void))cancelBlock sureBlock:(nullable void(^)(void))sureBlock{

//    LEEAlertConfig *leeAlertConfig = [LEEAlert alert];
//    LEEBaseConfigModel *config = leeAlertConfig.config;
//    config.LeeAddTitle(^(UILabel * _Nonnull label) {
//        label.text = title;
//        label.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightBold];
//        label.textColor = [UIColor zh_colorWithHexString:BlackHighColor];
//    });
//    if (message) {
//        config.LeeAddContent(^(UILabel *label) {
//            label.text = message;
//            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = [UIColor zh_colorWithHexString:BlackLowColor];
//        });
//    }
//    if (cancel) {
//        config.LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeCancel;
//            action.title = cancel;
//            action.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightBold];
//            action.clickBlock = ^{
//                if (cancelBlock) {
//                    cancelBlock();
//                }
//            };
//        });
//    }
//    config.LeeAddAction(^(LEEAction *action) {
//        action.title = sure != nil ? sure:@"确定";
//        action.font = [UIFont systemFontOfSize:15.0f];
//        action.clickBlock = ^{
//            if (sureBlock) {
//                sureBlock();
//            }
//        };
//    });
//    config.LeeBackgroundStyleTranslucent(0.4)
//    .LeeOpenAnimationStyle(LEEAnimationStyleOrientationNone)
//    .LeeCloseAnimationStyle(LEEAnimationStyleOrientationNone)
//    .LeeOpenAnimationDuration(0.1)
//    .LeeCloseAnimationDuration(0.1)
//    .LeeShow();
    
    NSMutableArray *button = [NSMutableArray array];
    if (cancel != nil) {
        [button addObject:cancel];
        [button addObject:sure];
    } else {
        [button addObject:sure];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int index = 0; index < button.count; index++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:button[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (index == 0) {
                if (cancelBlock) {
                    cancelBlock();
                }
            } else {
                if (sureBlock) {
                    sureBlock();
                }
            }
        }];
        
        [alertController addAction:action];
    }
    
    [[UIDevice zh_currentVc] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark ====== ActionSheet ======

+ (void)alerWithOptions:(NSArray *)options cancelStr:(nullable NSString *)cancelStr sectionTitle:(nullable NSString *)title select:(SelectBlock)callBack{
    
    LEEActionSheetConfig *actionSheetConfig = [LEEAlert actionsheet];
    LEEBaseConfigModel *config = actionSheetConfig.config;
    if (title) {
        config.LeeContent(title);
    }
    for (int i=0; i<options.count; i++) {
        NSString *item = options[i];
        config.LeeAddAction(^(LEEAction * _Nonnull action) {
            action.title = item;
            action.titleColor = [UIColor blackColor];
            action.font = [UIFont systemFontOfSize:15.0f];
            action.height = 50;
//            action.borderColor = kColorWithHex(0xe5e5e5);
            action.borderWidth = 0.5;
            action.clickBlock = ^{
                if (callBack) {
                    callBack(i,item);
                }
            };
        });
    }
    config.LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = cancelStr != nil ? cancelStr : @"取消";
        action.font = [UIFont systemFontOfSize:15.0f];
        action.height = 50;
        action.titleColor = [UIColor blackColor];
    });
    config.LeeActionSheetCancelActionSpaceColor([UIColor colorWithWhite:0.92 alpha:1.0f]) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
    .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

#pragma mark ====== PickerView ======

/// 弹出pickerView选择器
+ (void)showPickerWithOptions:(NSArray *)options sectionTitle:(nullable NSString *)title select:(SelectBlock)callBack{
    BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
    BRPickerStyle *style = [[BRPickerStyle alloc]init];
//    style.cancelTextColor = kColorWithHex(0x999999);
    stringPickerView.pickerStyle = style;
    stringPickerView.pickerMode = BRStringPickerComponentSingle;
    if (title) {
        stringPickerView.title = title;
    }
    stringPickerView.dataSourceArr = options;
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
    datePickerView.title = @"请选择时间";
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
