//
//  BaseTableView.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//
#define minValue 0.001f //注：不能是0，否则无效

#import "ZhTableView.h"

@interface ZhTableView ()

/// 头视图
@property (nonatomic, strong) UIView *defaultHeaderView;
/// 尾视图
@property (nonatomic, strong) UIView *defaultFooterView;

@end

@implementation ZhTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self config];
    }
    return self;
}

/// 统一配置
- (void)config{
    self.backgroundColor = kDefaultBackgrouncColor;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 15,*)) {
        self.sectionHeaderTopPadding = minValue;
    }
    
    if (@available(iOS 11,*)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
    self.estimatedRowHeight = UITableViewAutomaticDimension;
    self.estimatedSectionHeaderHeight = minValue;
    self.estimatedSectionFooterHeight = minValue;
    
    self.rowHeight = UITableViewAutomaticDimension;
    self.sectionHeaderHeight = minValue;
    self.sectionFooterHeight = minValue;
    
    self.tableHeaderView = self.defaultHeaderView;
    self.tableFooterView = self.defaultFooterView;
    
}


- (UIView *)defaultHeaderView{
    if (_defaultHeaderView == nil) {
        _defaultHeaderView = [[UIView alloc]init];
        _defaultHeaderView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, minValue);
        _defaultHeaderView.backgroundColor = UIColor.whiteColor;
    }
    return _defaultHeaderView;
}
- (UIView *)defaultFooterView{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc]init];
        _defaultFooterView.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, minValue);
        _defaultFooterView.backgroundColor = UIColor.whiteColor;
    }
    return _defaultFooterView;
}

@end
