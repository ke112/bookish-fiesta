//
//  NSString+ZhExt.h
//  OriginalPro
//
//  Created by ZhangZhihua on 2019/1/23.
//  Copyright © 2019 ZhangZhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZhSubmitting)

/**
 *  @author foxsofter, 15-04-02 15:04:59
 *
 *  @brief  按钮点击后，禁用按钮并在按钮上显示ActivityIndicator，以及title
 *
 *  @param title 按钮上显示的文字
 */
- (void)jk_beginSubmitting:(NSString *)title;

/**
 *  @author foxsofter, 15-04-02 15:04:13
 *
 *  @brief  按钮点击后，恢复按钮点击前的状态
 */
- (void)jk_endSubmitting;

/**
 *  @author foxsofter, 15-04-02 15:04:17
 *
 *  @brief  按钮是否正在提交中
 */
@property(nonatomic, readonly, getter=isJKSubmitting) NSNumber *jk_submitting;
@end
