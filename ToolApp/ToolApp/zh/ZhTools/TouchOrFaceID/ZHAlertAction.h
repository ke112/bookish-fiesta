//
//  ZHAlertAction.h
//  ToucheIDORFaceID
//
//  Created by zhangzhihua-imac on 2019/11/20.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHAlertAction : NSObject

/**
 *  模式对话框，选择一项
 *  @param title      标题
 *  @param message    提示内容
 *  @param arrayItems 按钮数组，“取消按钮” 请放第一个，系统显示有默认效果,example:@[@"取消",@"确认1",@"确认2",@"确认3",@"确认4",@"确认5",@"确认6"]
 *  @param block      点击事件，返回按钮顺序
 */
+ (void)showAlertWithTitle:(NSString*)title
                       msg:(NSString*)message
          buttonsStatement:(NSArray<NSString*>*)arrayItems
               chooseBlock:(void (^)(NSInteger buttonIdx))block;


/**
 *    显示UIActionSheet模式对话框
 *  @param title                  标题
 *  @param message                消息内容,大于ios8.0才会显示
 *  @param cancelString           取消按钮文本
 *  @param destructiveButtonTitle 特殊标记按钮，默认红色文字显示
 *  @param otherButtonArray       其他按钮数组,如 @[@"items1",@"items2",@"items3"]
 *  @param block                  返回block,buttonIdx:cancelString,destructiveButtonTitle分别为0、1,
 otherButtonTitle从后面开始，如果destructiveButtonTitle没有，buttonIndex1开始，反之2开始
 */
+ (void)showActionSheetWithTitle:(NSString*)title
                         message:(NSString*)message
               cancelButtonTitle:(NSString*)cancelString
          destructiveButtonTitle:(NSString*)destructiveButtonTitle
                otherButtonTitle:(NSArray<NSString*>*)otherButtonArray
                     chooseBlock:(void (^)(NSInteger buttonIdx))block;

@end

NS_ASSUME_NONNULL_END
