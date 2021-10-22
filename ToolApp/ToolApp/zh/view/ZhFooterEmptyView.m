//
//  ZhFooterEmptyView.m
//  EasyLife
//
//  Created by hshs on 2021/4/13.
//  Copyright © 2021 Hopson. All rights reserved.
//

#import "ZhFooterEmptyView.h"
#import <LYEmptyView/LYEmptyView.h>

@interface ZhFooterEmptyView ()

@property (nonatomic, strong) LYEmptyView *emptyView;

@end

@implementation ZhFooterEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.userInteractionEnabled = YES;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.frame = CGRectMake(0, 0, kScreenWidth, 400+kSafeAreaBottom);
    
    NSString *str = @"";
    NSString *img = @"";
    if (self.state == ZhEmptyLoadStateNoData) {
        str = @"暂无数据，请稍后再试~";
        img = @"newHouse_noData";
    } else if (self.state == ZhEmptyLoadStateFailure){
        str = @"内容加载失败，请重新加载~";
        img = @"newHouse_dataFailure";
    }
    __weak typeof(self) ws = self;
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:img
                                                             titleStr:str
                                                            detailStr:nil
                                                          btnTitleStr:@"重试"
                                                        btnClickBlock:^{
        [ws zh_refreshData];
    }];
    emptyView.titleLabFont = [UIFont systemFontOfSize:14];
    emptyView.titleLabTextColor = kColorWithHex(@"0x222222");
    emptyView.actionBtnCornerRadius = 4;
    emptyView.actionBtnBorderWidth = 1;
//    emptyView.actionBtnBorderColor = kColor_MainBlue;
//    emptyView.actionBtnTitleColor = kColor_MainBlue;
    emptyView.actionBtnWidth = 80;
    emptyView.actionBtnHeight = 33;
    emptyView.backgroundColor = kColorWithHex(@"0xF5F5F5");
    _emptyView = emptyView;
    [self.contentView addSubview:emptyView];
    
}
- (void)setState:(ZhEmptyLoadState)state{
    NSString *str = @"";
    NSString *img = @"";
    if (self.state == ZhEmptyLoadStateNoData) {
        str = @"暂无数据，请稍后再试~";
        img = @"newHouse_noData";
    } else if (self.state == ZhEmptyLoadStateFailure){
        str = @"内容加载失败，请重新加载~";
        img = @"newHouse_dataFailure";
    }
    _emptyView.titleStr = str;
    _emptyView.imageStr = img;
}

- (void)zh_refreshData{
    if (self.refreshDataBlock) {
        self.refreshDataBlock(self.state);
    }
}


@end
