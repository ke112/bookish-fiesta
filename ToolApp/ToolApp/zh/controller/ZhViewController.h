//
//  ZhViewController.h
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//  uiviewcontroller基类


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZhTableView.h"
#import "ZhCollectionView.h"
#import "ZhModel.h"
#import "UIViewController+ZhNavigation.h"
#import "ZhFooterEmptyView.h"
#import "NetWorkTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// 表格的风格  (默认写了UITableViewStyleGrouped) 可重写
@property (nonatomic, assign) UITableViewStyle tableStyle;
/// 表格
@property (nonatomic, strong, nullable) ZhTableView *tableView;
/// 集合视图的滚动方向  (默认UICollectionViewScrollDirectionVertical) 可重写
@property (nonatomic, assign) UICollectionViewScrollDirection layoutDirection;
/// 集合视图
@property (nonatomic, strong, nullable) ZhCollectionView *collectionView;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 请求页码数
@property (nonatomic, assign) NSInteger pageNum;
/// 请求个数
@property (nonatomic, assign) NSInteger pageSize;
/// 跳转vc的传参
@property (nonatomic, strong) NSMutableDictionary *vcParam;

#pragma mark ====== LYEmptyView管理EmptyView ======
/// 网络加载无数据/失败
@property (nonatomic, assign) ZhEmptyLoadState zh_emptyLoadState;
/// 点击刷新数据回调
@property (nonatomic, copy) void (^refreshDataBlock)(ZhEmptyLoadState state);

/// 空视图在垂直方向的向下偏移量
@property (nonatomic, assign) CGFloat zh_emptyOffset;
/// 空视图在垂直方向的纵坐标大小
@property (nonatomic, assign) CGFloat zh_emptyOffY;
/// 禁止侧滑 设为YES
@property (nonatomic, assign) BOOL disableSideslip;

#pragma mark ====== 导航栏状态栏管理 ======
/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 导航栏背景色
@property (nonatomic, strong) UIColor *naviBarColor;
/// 导航栏标题色
@property (nonatomic, strong) UIColor *naviTitleColor;
/// 导航栏标题子图
@property (nonatomic, strong) UIFont *naviTitleFont;
/// 导航栏左右按钮颜色
@property (nonatomic, strong) UIColor *naviItemColor;
/// 导航栏透明度
@property (nonatomic, assign) float naviBarAlpha;
/// 是否隐藏导航栏
@property (nonatomic, assign) BOOL naviBarHidden;
/// 是否状态栏白色显示风格
@property (nonatomic, assign) BOOL statusBarWhite;

/// 更新导航栏白色色显示风格
- (void)updateStatusBarStyleWhite:(BOOL)isWhite;
/// 是否隐藏状态栏
- (void)updateStatusBarHidden:(BOOL)hidden;


/// 手动隐藏emptyView
- (void)zh_hideEmptyView;
/// 手动显示emptyView
- (void)zh_showEmptyView;
/// 开始不显示无数据
- (void)zh_startLoading;
/// 自动去判断有无数据
- (void)zh_endLoading;

#pragma mark ====== FooterView管理EmptyView ======
@property (nonatomic, strong) ZhFooterEmptyView *footerEmptyView;

/// 隐藏emptyFooterView
- (void)zh_hideFooterEmptyView;
/// 显示emptyFooterView
- (void)zh_showFooterEmptyView:(ZhEmptyLoadState)state;

#pragma mark ====== 导航按钮管理 ======
/**设置默认黑色返回箭头*/
- (UIButton *)showDefaultBackNaviWithAction;
/**设置白色返回箭头*/
- (UIButton *)showWhiteBackNaviWithAction;
/// 自定义返回按钮事件
@property (nonatomic, copy) void(^onClickLeftButton)(void);

/**自定义返回按钮图片和事件*/
- (UIButton *)setLeftNavWithImage:(NSString *)image target:(id)target action:(SEL)action;
/**自定义返回按钮文字和事件*/
- (UIButton *)setLeftNavWithTitle:(NSString *)title target:(id)target action:(SEL)action;
/**自定义右上角按钮图片和事件*/
- (UIButton *)setRightNavWithImage:(NSString *)image target:(id)target action:(SEL)action;
/**自定义右上角按钮文字和事件*/
- (UIButton *)setRightNavWithTitle:(NSString *)title target:(id)target action:(SEL)action;

///导航栏事件回调
typedef void (^NaviEventBlock)(NSInteger index);
/// 自定义右上角多个按钮图片和事件
- (NSMutableArray<UIButton *> *)setRightNavWithImages:(NSArray<NSString *> *)images andAction:(NaviEventBlock)event;
/// 自定义左上角多个按钮图片和事件
- (NSMutableArray<UIButton *> *)setLeftNavWithImages:(NSArray<NSString *> *)images andAction:(NaviEventBlock)event;

/**基类返回按钮方法  默认有动画效果*/
- (void)backEvent;
/**基类返回按钮方法  没有动画效果*/
- (void)backEventNoAnimation;
/**隐藏导航栏左侧按钮*/
- (void)hideDefaultBackNavi;
/// 隐藏导航栏右侧按钮
- (void)hideRightNaviButton;

#pragma mark ====== 子类需要重写方法 ======
/// 设置导航栏
- (void)setNavi;
/// 设置界面布局
- (void)setUI;
/// 获取数据
- (void)setData;

#pragma mark ====== 分页需要重写的方法 ======
/// 重置分页数据
- (void)pages_loadFirst;
/// 分页请求的重写方法
- (void)pages_loadData;
/// 上拉加载的方法 (内部使用)
//- (void)pages_loadMore;
/// 添加下拉刷新
- (void)pages_addDownPullRefresh;
/// 添加上拉刷新
- (void)pages_addUpPullRefresh;
/// 结束刷新状态
- (void)endRefreshState;

/// 设置当前控制器为暗黑模式
- (void)setInterfaceStyleIsDarkModel:(BOOL)isDarkModel;
/// 暗黑模式改变的回调
@property (nonatomic, copy) void (^InterfaceStyleDidChangeBlock)(BOOL isDarkModel);

/// 分页请求方法(带有上拉刷新)
- (__kindof NSURLSessionDataTask *)GETPage:(NSString *)interface
                                parameters:(nullable id)parameters
                               showLoading:(BOOL)showLoading
                                modelClass:(Class)modelClass
                                   success:(RequestSucceedBlock)requestSuccess
                                   failure:(RequestFailBlock)requestFail;

@end

NS_ASSUME_NONNULL_END
