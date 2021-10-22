//
//  UITabBar+ZhBadge.h
//  自定义TabBar小红点
//
//  Created by laidongling on 17/7/12.
//  Copyright © 2017年 LaiDongling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (ZhBadge)

@property(nonatomic,assign) CGSize zh_badgeSize;        //小红点size
@property(nonatomic,strong)UIImage *zh_badgeImage;      //小红点图片
@property(nonatomic,strong)UIColor *zh_badgeColor;      //小红点颜色

//显示小红点
- (void)zh_showBadgeOnItemIndex:(NSUInteger)index;

//隐藏小红点
- (void)zh_hiddenRedPointOnIndex:(NSUInteger)index animation:(BOOL)animation;

@end
