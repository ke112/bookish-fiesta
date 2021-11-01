//
//  BaseTableCell.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhTableCell : UITableViewCell


///子类去重写
- (void)setUI;

///添加顶部分割线(常用)
- (void)addTopLine;
///添加底部分割线
- (void)addBottomLine;
///清空顶部底部分割线
- (void)clearTopBottomLine;

///添加右侧箭头
- (void)addRightArrow;
///移除右侧箭头
- (void)removeRightArrow;

///白色背景视图
@property (nonatomic, strong) UIView *whiteShadowBgView;

/// 上面的线
@property (nonatomic, strong) UIView *topLineView;
/// 下面的线
@property (nonatomic, strong) UIView *bottomLineView;

///头像
@property (nonatomic, strong) UIImageView *iconImg;
///标题
@property (nonatomic, strong) UILabel *titleLb;
///内容
@property (nonatomic, strong) UILabel *contentLb;

///.h设置行数,重写setter方法
@property (nonatomic, assign) NSIndexPath *indexPath;
///.m使用行数,上边属性setter方法内赋值,其他地方使用
@property (nonatomic, assign) NSIndexPath *innerIndexPath;
///右侧箭头视图
@property (nonatomic, strong) UIImageView *arrowRightImg;


@end

NS_ASSUME_NONNULL_END
