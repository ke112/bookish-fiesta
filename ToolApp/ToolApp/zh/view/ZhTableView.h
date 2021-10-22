//
//  BaseTableView.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhTableView : UITableView
/// <UITableViewDataSource,UITableViewDelegate>

/// 头视图
@property (nonatomic, strong) UIView *defaultHeaderView;
/// 尾视图
@property (nonatomic, strong) UIView *defaultFooterView;

/// 刷新当前cell
- (void)zh_reloadCell:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
