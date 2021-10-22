//
//  ZhFooterEmptyView.h
//  EasyLife
//
//  Created by hshs on 2021/4/13.
//  Copyright © 2021 Hopson. All rights reserved.
//

typedef NS_ENUM(NSInteger,ZhEmptyLoadState){
    ZhEmptyLoadStateNoData = 0, //无数据
    ZhEmptyLoadStateFailure = 1 //网络请求错误
};

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhFooterEmptyView : UITableViewHeaderFooterView

@property (nonatomic, assign) ZhEmptyLoadState state;

/// 点击刷新数据回调
@property (nonatomic, copy) void (^refreshDataBlock)(ZhEmptyLoadState state);

@end

NS_ASSUME_NONNULL_END
