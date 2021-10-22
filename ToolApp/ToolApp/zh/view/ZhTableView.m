//
//  BaseTableView.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhTableView.h"

@interface ZhTableView ()

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
//    self.delegate = self;
//    self.dataSource = self;
    self.backgroundColor = kDefaultBackgrouncColor;
    
    if (@available(iOS 15,*)) {
        self.sectionHeaderTopPadding = 0;
    }
    if (@available(iOS 11,*)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        
    }
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rowHeight = UITableViewAutomaticDimension;
    self.estimatedRowHeight = 100;
    
    self.sectionHeaderHeight = 0.01;
    self.sectionFooterHeight = 0.01;
    
    self.tableHeaderView = self.defaultHeaderView;
    self.tableFooterView = self.defaultFooterView;
    
}

- (void)zh_reloadCell:(NSIndexPath *)indexPath{
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self endUpdates];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    // Return the number of sections.
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    // Return the number of rows in the section.
//    return 0;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    // Configure the cell...
//
//    return cell;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewAutomaticDimension;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self.zh_viewController.view endEditing:YES];
//}

- (UIView *)defaultHeaderView{
    if (_defaultHeaderView == nil) {
        _defaultHeaderView = [[UIView alloc]init];
        _defaultHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
        _defaultHeaderView.backgroundColor = kColorWithHex(@"0xF9F9F9");
    }
    return _defaultHeaderView;
}
- (UIView *)defaultFooterView{
    if (_defaultFooterView == nil) {
        _defaultFooterView = [[UIView alloc]init];
        _defaultFooterView.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
        _defaultFooterView.backgroundColor = kColorWithHex(@"0xF9F9F9");
    }
    return _defaultFooterView;
}

@end
