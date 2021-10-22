//
//  UIScrollView+BaseRefresh.m
//  PearPsyEnterprise
//
//  Created by ZhangZhihua on 2018/12/27.
//  Copyright © 2018 Brightease. All rights reserved.
//

#import "UIScrollView+BaseRefresh.h"
#import <MJRefresh.h>
#import <LYEmptyViewHeader.h>

@implementation UIScrollView (BaseRefresh)

/**
 设置头部刷新
 */
- (void)headerRefreshTarget:(nullable id)target action:(SEL)action{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.automaticallyChangeAlpha = YES;
    header.arrowView.image = nil;
    header.stateLabel.hidden = YES;
    [header.lastUpdatedTimeLabel setHidden:YES];
    self.mj_header = header;
}
/**
 设置头部刷新
 */
- (void)headerRefreshWithBlock:(void (^)(void))block{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.automaticallyChangeAlpha = YES;
    header.arrowView.image = nil;
    header.stateLabel.hidden = YES;
    [header.lastUpdatedTimeLabel setHidden:YES];
    self.mj_header = header;
}
/**
 开始头部刷新
 */
- (void)beginHeaderRefresh{
    [self.mj_header beginRefreshing];
}

/**
 结束头部刷新
 */
- (void)endHeaderRefresh{
    [self.mj_header endRefreshing];
}


/**
 设置底部刷新
 */
- (void)footerRefreshTarget:(nullable id)target action:(SEL)action{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.triggerAutomaticallyRefreshPercent = 0;
    footer.automaticallyRefresh = YES;
    self.mj_footer = footer;
}
/**
 设置底部刷新
 */
- (void)footerRefreshWithBlock:(void (^)(void))block{
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:block];
    footer.triggerAutomaticallyRefreshPercent = 0;
    footer.automaticallyRefresh = YES;
    self.mj_footer = footer;
}
/**
 开始底部刷新
 */
- (void)beginFooterRefresh{
    [self.mj_footer beginRefreshing];
}

/**
 结束底部刷新
 */
- (void)endFooterRefresh{
    [self.mj_footer endRefreshing];
}

/**
 底部没有更多数据
 */
- (void)footerNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}
/**
 隐藏头部刷新
 */
- (void)headerHidden:(BOOL)hidden{
    self.mj_header.hidden = hidden;
}
/**
 隐藏底部刷新
 */
- (void)footerHidden:(BOOL)hidden{
    self.mj_footer.hidden = hidden;
}

/// 空数据视图提示文字
- (void)noMoreDataTip:(NSString *)tip{
    self.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@""
     titleStr:@""
    detailStr:tip];
    self.ly_emptyView.detailLabTextColor = [UIColor zh_colorWithHexString:@"#CCCCCC"];
    self.ly_emptyView.detailLabFont = [UIFont systemFontOfSize:15];
    self.ly_emptyView.detailLabMaxLines = 100;
}

/// 空数据视图 图片+文字
- (void)noMoreDataType:(NSInteger)type Tip:(NSString *)tip{
    [self noMoreDataType:type Tip:tip btnText:nil target:nil action:nil];
}

/// 空数据视图 图片+文字+按钮名字+事件
- (void)noMoreDataType:(NSInteger)type Tip:(NSString *)tip btnText:(nullable NSString *)btnText target:(nullable id)target action:(nullable SEL)action{
    NSString *imgs = @"";
    switch (type) {
        case 0:{ //服务器出逃 骑自行车
            imgs = @"place_network";
        }break;
        case 1:{ //断网界面 拿着手机连wifi
            imgs = @"place_networkerror";
        }break;
        case 2:{ //没有数据 低头看放大镜
            imgs = @"place_psyFile";
        }break;
        case 3:{ //没有私信 抱着信封
            imgs = @"place_sixinlist";
        }break;
        case 4:{ //抬头看计划 看报纸
            imgs = @"place_tmpSche";
        }break;
        default:{
        }break;
    }
    self.ly_emptyView = [LYEmptyView emptyActionViewWithImageStr:imgs titleStr:@"" detailStr:tip btnTitleStr:btnText target:target action:action];
    self.ly_emptyView.detailLabTextColor = [UIColor zh_colorWithHexString:@"#CCCCCC"];
    self.ly_emptyView.detailLabFont = [UIFont systemFontOfSize:15];
    
    self.ly_emptyView.actionBtnBorderWidth = 1;
//    self.ly_emptyView.actionBtnBorderColor = [UIColor zh_colorWithHexString:MainThemeColor];
    self.ly_emptyView.actionBtnFont = [UIFont systemFontOfSize:15];
//    self.ly_emptyView.actionBtnTitleColor = [UIColor zh_colorWithHexString:MainThemeColor];
    self.ly_emptyView.actionBtnCornerRadius = 23;
    self.ly_emptyView.actionBtnHeight = 45;
    self.ly_emptyView.actionBtnWidth = 150;
}
/// 隐藏问题没有数据空视图文字
-(void)hideNoMoreDataTip{
    [self noMoreDataTip:@""];
}

@end
