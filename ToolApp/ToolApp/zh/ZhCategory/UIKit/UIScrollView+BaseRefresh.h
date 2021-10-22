//
//  UIScrollView+BaseRefresh.h
//  PearPsyEnterprise
//
//  Created by ZhangZhihua on 2018/12/27.
//  Copyright © 2018 Brightease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (BaseRefresh)

/// 设置头部刷新
- (void)headerRefreshTarget:(nullable id)target action:(SEL)action;

/// 设置头部刷新
- (void)headerRefreshWithBlock:(void (^)(void))block;

/// 开始头部刷新
- (void)beginHeaderRefresh;

/// 结束头部刷新
- (void)endHeaderRefresh;

/// 设置底部刷新
- (void)footerRefreshTarget:(nullable id)target action:(SEL)action;

/// 设置底部刷新
- (void)footerRefreshWithBlock:(void (^)(void))block;

/// 开始底部刷新
- (void)beginFooterRefresh;

/// 结束底部刷新
- (void)endFooterRefresh;

/// 底部没有更多数据
- (void)footerNoMoreData;

/// 隐藏头部刷新
- (void)headerHidden:(BOOL)hidden;

/// 隐藏底部刷新
- (void)footerHidden:(BOOL)hidden;

/// 空数据视图提示文字
- (void)noMoreDataTip:(NSString *)tip;

/// 空数据视图 图片+文字
/// @param type 类型
/// @param tip 文字
- (void)noMoreDataType:(NSInteger)type Tip:(NSString *)tip;

/// 空数据视图 图片+文字+按钮名字+事件
/// @param type 类型
/// @param tip 文字
/// @param btnText 按钮名字
/// @param target 对象
/// @param action 事件
- (void)noMoreDataType:(NSInteger)type Tip:(NSString *)tip btnText:(nullable NSString *)btnText target:(nullable id)target action:(nullable SEL)action;

/// 隐藏问题没有数据空视图文字
-(void)hideNoMoreDataTip;


@end

NS_ASSUME_NONNULL_END
