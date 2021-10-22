//
//  UIButton+ZhExpandAera.h
//  WeDriveCoach
//
//  Created by 张志华 on 2/27/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//  扩大按钮点击区域的分类

#import <UIKit/UIKit.h>

typedef struct ZHClickEdgeInsets {
    
    CGFloat top,left,bottom,right;
    
} ZHClickEdgeInsets;

UIKIT_STATIC_INLINE ZHClickEdgeInsets ZHClickEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    
    ZHClickEdgeInsets clickEdgeInsets = {top, left, bottom, right};
    return clickEdgeInsets;
}

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZhExpandAera)

/**
 改变button的点击范围
 length:范围边缘距离（四个边缘同样距离）
 */
- (void)zh_AddClickLength:(CGFloat)length;

/**
 改变button的点击范围
 edgeInsets:范围边缘距离
 */
- (void)zh_AddClickRange:(ZHClickEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
