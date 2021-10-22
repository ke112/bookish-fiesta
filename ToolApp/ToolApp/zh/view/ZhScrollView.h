//
//  ZhScrollView.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhScrollView : UIScrollView<UIScrollViewDelegate>

/// 填充内容的父视图
@property (nonatomic, strong) UIView *contentView;

/// 设置背景颜色
@property (nonatomic, strong) UIColor *bgColor;

/// 子类重写方法
- (void)setUI;

/// 子类调用 创建一个间隔视图
- (UIView *)makeMarginView;

/// 子类调用 显示所有的子视图的背景颜色
- (void)showSubViewBackgroundColor;


@end

NS_ASSUME_NONNULL_END
