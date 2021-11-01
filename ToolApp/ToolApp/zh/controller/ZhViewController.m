//
//  ZhViewController.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhViewController.h"
#import <objc/runtime.h>
#import "UIDevice+ZhExt.h"
#import "UIBarButtonItem+ZhNavigationBar.h"
#import "ZhAlertTool.h"
#import "ZhSystemTool.h"

#if __has_include(<LYEmptyView/LYEmptyViewHeader.h>)
#import <LYEmptyView/LYEmptyViewHeader.h>
#elif __has_include("LYEmptyViewHeader.h")
#import "LYEmptyViewHeader.h"
#endif

#if __has_include(<MJRefresh/MJRefresh.h>)
#import <MJRefresh/MJRefresh.h>
#elif __has_include("MJRefresh.h")
#import "MJRefresh.h"
#endif

static char *naviAlphaKey = @"naviAlphaKey";

@interface ZhViewController ()
/// (内部使用)子类vc是否有分页请求
@property (nonatomic, assign) BOOL isHaveGetPageVc;
/// (内部使用)2个导航点击的回调
@property (nonatomic, copy) NaviEventBlock leftEventBlock;
@property (nonatomic, copy) NaviEventBlock rightEventBlock;
/// (内部使用)状态栏样式
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// (内部使用)状态栏隐藏
@property (nonatomic, assign) BOOL statusBarHidden;
///// (内部使用)导航栏透明度
@property (nonatomic, copy) NSString *rt_naviAlpha;

@end

@implementation ZhViewController

/// 控制状态栏的样式 (要刷新状态栏，让其重新执行该方法需要调用{-setNeedsStatusBarAppearanceUpdate})
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _statusBarStyle;
}
/// 状态栏显示还是隐藏 (要刷新状态栏，让其重新执行该方法需要调用{-setNeedsStatusBarAppearanceUpdate})
- (BOOL)prefersStatusBarHidden{
    return _statusBarHidden;
}
/// 状态栏改变的动画，这个动画只影响状态栏的显示和隐藏
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationSlide;
}
/// 当前类销毁
- (void)dealloc{
    NSLog(@"\nvc类 %@ 销毁了\n",self);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configNaviBar];
    
    NSString *naviAlpha = self.rt_naviAlpha;
    if (self.navigationController.navigationBar.alpha != naviAlpha.floatValue) {
        self.navigationController.navigationBar.alpha = naviAlpha.floatValue;
        NSLog(@"导航栏透明度变了 %@ %@",naviAlpha,self);
    }else{
        NSLog(@"导航栏透明度没变 %@",self);
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.disableSideslip;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBar.translucent = NO;
    self.backgroundColor = kDefaultBackgrouncColor;
    self.tableStyle = UITableViewStyleGrouped;
    self.pageNum = 1;
    self.pageSize = 10;
    if (self.navigationController.viewControllers.count == 1) {
        [self hideDefaultBackNavi];
    } else {
        [self showDefaultBackNaviWithAction];
    }
//    [self handleNetWork];
    __weak typeof(self) ws = self;
    self.footerEmptyView.refreshDataBlock = ^(ZhEmptyLoadState state) {
        ws.refreshDataBlock(state);
    };
}

#pragma mark ====== 处理网络相关问题 ======
/// 处理网络相关问题
- (void)handleNetWork{
    if ([UIDevice zh_isAirPlane]) {
        [ZhAlertTool showAlertWithTitle:@"关闭飞行模式或使用无线局域网来访问数据" message:nil doneTitle:@"设置" sureBlock:^{
            [ZhSystemTool openAppPrivacySettings];
        } cancelTitle:@"好" cancelBlock:nil];
    } else {
        if (![UIDevice zh_isNetwork]) {
            [ZhAlertTool showAlertWithTitle:@"关闭飞行模式或使用无线局域网来访问数据" message:nil doneTitle:@"设置" sureBlock:^{
                [ZhSystemTool openAppPrivacySettings];
            } cancelTitle:@"好" cancelBlock:nil];
        }else{
//            NSLog(@"正常有网");
        }
    }
}

#pragma mark ====== LYEmptyView管理EmptyView ======
- (void)setZh_emptyLoadState:(ZhEmptyLoadState)zh_emptyLoadState{
    _zh_emptyLoadState = zh_emptyLoadState;
    
    NSString *str = @"";
    NSString *img = @"";
    if (zh_emptyLoadState == ZhEmptyLoadStateNoData) {
        str = @"暂无数据，请稍后再试~";
        img = @"newHouse_noData";
    } else if (zh_emptyLoadState == ZhEmptyLoadStateFailure){
        str = @"内容加载失败，请重新加载~";
        img = @"newHouse_dataFailure";
    }
    __weak typeof(self) ws = self;
    for (int i=0; i<2; i++) {
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:img
                                                                 titleStr:str
                                                                detailStr:nil
                                                              btnTitleStr:@"重试"
                                                            btnClickBlock:^{
            [ws zh_LYEmptyRefreshData];
        }];
        emptyView.titleLabFont = [UIFont systemFontOfSize:14];
        emptyView.titleLabTextColor = kColorWithHex(0x222222);
        emptyView.actionBtnCornerRadius = 4;
        emptyView.actionBtnBorderWidth = 1;
//        emptyView.actionBtnBorderColor = kColor_MainBlue;
//        emptyView.actionBtnTitleColor = kColor_MainBlue;
        emptyView.actionBtnWidth = 80;
        emptyView.actionBtnHeight = 33;
        emptyView.backgroundColor = kDefaultBackgrouncColor;
        
        if (i == 0) {
            self.tableView.ly_emptyView = emptyView;
            [self.tableView ly_showEmptyView];
        } else {
            self.collectionView.ly_emptyView = emptyView;
            [self.collectionView ly_showEmptyView];
        }
    }
}
/// 空视图在垂直方向的向下偏移量
- (void)setZh_emptyOffset:(CGFloat)zh_emptyOffset{
    _zh_emptyOffset = zh_emptyOffset;
    self.tableView.ly_emptyView.contentViewOffset = zh_emptyOffset;
    self.collectionView.ly_emptyView.contentViewOffset = zh_emptyOffset;
}
/// 空视图在垂直方向的纵坐标大小
- (void)setZh_emptyOffY:(CGFloat)zh_emptyOffY{
    _zh_emptyOffY = zh_emptyOffY;
    self.tableView.ly_emptyView.contentViewY = zh_emptyOffY;
    self.collectionView.ly_emptyView.contentViewY = zh_emptyOffY;
}
/// 手动隐藏emptyView
- (void)zh_hideEmptyView{
    [self.tableView ly_hideEmptyView];
    [self.collectionView ly_hideEmptyView];
}
/// 手动显示emptyView
- (void)zh_showEmptyView{
    [self.tableView ly_showEmptyView];
    [self.collectionView ly_showEmptyView];
}
/// 开始不显示无数据
- (void)zh_startLoading{
    [self.tableView ly_startLoading];
    [self.collectionView ly_startLoading];
}
/// 自动去判断有无数据
- (void)zh_endLoading{
    [self.tableView ly_endLoading];
    [self.collectionView ly_endLoading];
}

/// 使用LYEmptyView时的刷新回调方法
- (void)zh_LYEmptyRefreshData{
    if (self.refreshDataBlock) {
        self.refreshDataBlock(self.zh_emptyLoadState);
    }
}
/// 隐藏emptyvView
- (void)zh_hideFooterEmptyView{
    self.tableView.tableFooterView = nil;
}
/// 显示emptyFooterView
- (void)zh_showFooterEmptyView:(ZhEmptyLoadState)state{
    [self.tableView ly_hideEmptyView];
    self.tableView.tableFooterView = self.footerEmptyView;
    self.footerEmptyView.state = state;
}
#pragma mark ====== 导航栏状态栏管理 ======
- (void)setRt_naviAlpha:(NSString *)rt_naviAlpha{
    objc_setAssociatedObject(self, naviAlphaKey, rt_naviAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)rt_naviAlpha{
    NSString *naviAlpha = objc_getAssociatedObject(self, naviAlphaKey);
    return naviAlpha ? : @"1";
}
/// 背景色
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    self.tableView.backgroundColor = backgroundColor;
    self.collectionView.backgroundColor = backgroundColor;
}
/// 导航栏背景色
- (void)setNaviBarColor:(UIColor *)naviBarColor{
    _naviBarColor = naviBarColor;
    [self configNaviBar];
}
/// 导航栏标题色
- (void)setNaviTitleColor:(UIColor *)naviTitleColor{
    _naviTitleColor = naviTitleColor;
    [self configNaviBar];
}
/// 导航栏标字体
- (void)setNaviTitleFont:(UIFont *)naviTitleFont{
    _naviTitleFont = naviTitleFont;
    [self configNaviBar];
}
/// 导航栏左右按钮颜色
- (void)setNaviItemColor:(UIColor *)naviItemColor{
    _naviItemColor = naviItemColor;
    [self configNaviBar];
}
/// 更新导航栏黑色显示风格
/// 更新导航栏白色色显示风格
- (void)updateStatusBarStyleWhite:(BOOL)isWhite{
    self.statusBarWhite = isWhite;
    if (isWhite == NO) {
        [self showDefaultBackNaviWithAction];
        if (@available(iOS 13.0, *)) {
            self.naviTitleColor = UIColor.labelColor;
            self.naviItemColor = UIColor.labelColor;
        }else{
            self.naviTitleColor = UIColor.blackColor;
            self.naviItemColor = UIColor.blackColor;
        }
    }else{
        [self showWhiteBackNaviWithAction];
        if (@available(iOS 13.0, *)) {
            self.naviTitleColor = UIColor.systemBackgroundColor;
            self.naviItemColor = UIColor.systemBackgroundColor;
        }else{
            self.naviTitleColor = UIColor.whiteColor;
            self.naviItemColor = UIColor.whiteColor;
        }
    }
    [self configNaviBar];
}
/// 是否状态栏白色显示风格
- (void)setStatusBarWhite:(BOOL)statusBarWhite{
    if (statusBarWhite) {
        _statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        _statusBarStyle = UIStatusBarStyleDefault;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}
/// 是否隐藏状态栏
- (void)updateStatusBarHidden:(BOOL)hidden{
    _statusBarHidden = hidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
/// 导航栏透明度
- (void)setNaviBarAlpha:(float)naviBarAlpha{
    _naviBarAlpha = naviBarAlpha;
    self.rt_naviAlpha = [NSString stringWithFormat:@"%f",naviBarAlpha];
    if (naviBarAlpha == 0) {
        self.naviBarColor = UIColor.clearColor;
    }
}
/// 是否隐藏导航栏
- (void)setNaviBarHidden:(BOOL)naviBarHidden{
    _naviBarHidden = naviBarHidden;
    if (naviBarHidden) {
        self.naviBarAlpha = 0;
    }else{
        self.naviBarAlpha = 1;
    }
}
/// 统一设置
- (void)configNaviBar{
    ///导航栏背景色
    UIColor *naviBarColor;
    ///导航栏标题色
    UIColor *naviTitleColor;
    ///导航栏左右按钮颜色
    UIColor *naviItemColor;
    if (@available(iOS 13.0, *)) {
        naviBarColor = self.naviBarColor ? : UIColor.systemBackgroundColor;
        naviTitleColor = self.naviTitleColor ? : UIColor.labelColor;
        naviItemColor = self.naviItemColor ? : UIColor.labelColor;
    }else{
        naviBarColor = self.naviBarColor ? : UIColor.whiteColor;
        naviTitleColor = self.naviTitleColor ? : UIColor.blackColor;
        naviItemColor = self.naviItemColor ? : UIColor.blackColor;
    }
    ///导航栏标题字体
    UIFont *naviTitleFont = self.naviTitleFont ? : [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    // 字体颜色、尺寸等
    NSDictionary<NSAttributedStringKey, id> *naviTitleTextAttributes = @{
        NSForegroundColorAttributeName : naviTitleColor,
        NSFontAttributeName : naviTitleFont,
    };
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = naviBarColor;  // 背景色
        appearance.shadowColor = [UIColor clearColor];  // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线)
        appearance.titleTextAttributes = naviTitleTextAttributes;  // 字体颜色、尺寸等
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;  // 带scroll滑动的页面
        self.navigationController.navigationBar.standardAppearance = appearance;  // 常规页面
    }else{
        self.navigationController.navigationBar.barTintColor = naviBarColor;
        self.navigationController.navigationBar.titleTextAttributes = naviTitleTextAttributes;
    }
    ///导航栏左右按钮颜色
    self.navigationController.navigationBar.tintColor = naviItemColor;
}

#pragma mark ====== 导航按钮管理 ======
- (UIButton *)showDefaultBackNaviWithAction{
    return [self setLeftNavWithImage:@"back_style1_black" target:self action:@selector(backEvent)];
}
- (UIButton *)showWhiteBackNaviWithAction{
    return [self setLeftNavWithImage:@"back_style1_white" target:self action:@selector(backEvent)];
}

- (UIButton *)setLeftNavWithImage:(NSString *)image target:(id)target action:(SEL)action{
    UIBarButtonItem *base_leftBtn = [UIBarButtonItem itemWithTarget:target action:action image:[UIImage imageNamed:image] imageEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.leftBarButtonItem = base_leftBtn;
    return (UIButton *)base_leftBtn.customView;
}
- (UIButton *)setLeftNavWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *base_leftBtn = [UIBarButtonItem itemWithTarget:target action:action title:title font:[UIFont systemFontOfSize:16] titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.leftBarButtonItem = base_leftBtn;
    return (UIButton *)base_leftBtn.customView;
}
- (UIButton *)setRightNavWithImage:(NSString *)image target:(id)target action:(SEL)action{
    UIBarButtonItem *base_rightBtn = [UIBarButtonItem itemWithTarget:target action:action image:[UIImage imageNamed:image] imageEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.rightBarButtonItem = base_rightBtn;
    return (UIButton *)base_rightBtn.customView;
}
- (UIButton *)setRightNavWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *base_rightBtn = [UIBarButtonItem itemWithTarget:target action:action title:title font:[UIFont systemFontOfSize:16] titleColor:nil highlightedColor:nil titleEdgeInsets:UIEdgeInsetsZero];
    self.navigationItem.rightBarButtonItem = base_rightBtn;
    return (UIButton *)base_rightBtn.customView;
}
/// 自定义右上角多个按钮图片和事件
- (NSMutableArray<UIButton *> *)setRightNavWithImages:(NSArray<NSString *> *)images andAction:(NaviEventBlock)event{
    return [self setNaviWithImages:images andAction:event isLeft:NO];
}
/// 自定义左上角多个按钮图片和事件
- (NSMutableArray<UIButton *> *)setLeftNavWithImages:(NSArray<NSString *> *)images andAction:(NaviEventBlock)event{
    return [self setNaviWithImages:images andAction:event isLeft:YES];
}
/// 统一设置导航栏多个图片按钮
- (NSMutableArray<UIButton *> *)setNaviWithImages:(NSArray<NSString *> *)images andAction:(NaviEventBlock)event isLeft:(BOOL)isLeft{
    NSMutableArray *buttonItems = [NSMutableArray array];
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i=0; i<images.count; i++) {
        NSString *image = images[i];
        UIBarButtonItem *buttonItem = [UIBarButtonItem itemWithTarget:self action:nil image:[UIImage imageNamed:image] imageEdgeInsets:UIEdgeInsetsZero];
        [buttonItems addObject:buttonItem];
        
        UIButton *customBtn = (UIButton *)buttonItem.customView;
        customBtn.tag = 1000+i;
        if (isLeft) {
            [customBtn addTarget:self action:@selector(leftNaviEventClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [customBtn addTarget:self action:@selector(leftNaviEventClick:) forControlEvents:UIControlEventTouchUpInside];
        }
//        customBtn.backgroundColor = kRandomColor;
        [buttons addObject:customBtn];
    }
    if (isLeft) {
        self.leftEventBlock = event;
        self.navigationItem.leftBarButtonItems = buttonItems;
    }else{
        self.rightEventBlock = event;
        self.navigationItem.rightBarButtonItems = buttonItems;
    }
    return buttons;
}
- (void)leftNaviEventClick:(UIButton *)sender{
    if (self.leftEventBlock) {
        self.leftEventBlock(sender.tag-1000);
    }
}
- (void)rightNaviEventClick:(UIButton *)sender{
    if (self.rightEventBlock) {
        self.rightEventBlock(sender.tag-1000);
    }
}

#pragma mark - 返回点击事件
- (void)backEvent{
    [self.view endEditing:YES];
    if (self.onClickLeftButton) {
        self.onClickLeftButton();
    }else{
        if (self.navigationController) {
            if (self.navigationController.viewControllers.count == 1) {
                if (self.presentingViewController) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else if(self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
/**基类返回按钮方法  没有动画效果*/
- (void)backEventNoAnimation{
    [self.view endEditing:YES];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
/**隐藏导航栏左侧按钮*/
- (void)hideDefaultBackNavi{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}
/// 隐藏导航栏右侧按钮
- (void)hideRightNaviButton{
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)setTableStyle:(UITableViewStyle)tableStyle{
    _tableStyle = tableStyle;
    self.tableView = nil;
}

/// 重置分页数据
- (void)pages_loadFirst{
    self.isHaveGetPageVc = NO; //恢复默认
    self.pageNum = 1;
    [self pages_loadData];
}

/// 分页请求的重写方法
- (void)pages_loadData{
    
}
/// 上拉加载的方法 (内部使用)
- (void)pages_loadMore{
    self.pageNum += 1;
    [self pages_loadData];
}

/// 添加下拉刷新
- (void)pages_addDownPullRefresh{
    __weak typeof(self) ws = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [ws pages_loadFirst];
    }];
    self.collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [ws pages_loadFirst];
    }];
}
/// 添加上拉刷新
- (void)pages_addUpPullRefresh{
    __weak typeof(self) ws = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws pages_loadMore];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws pages_loadMore];
    }];
}

/// 结束刷新状态
- (void)endRefreshState{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

/// 设置当前控制器为暗黑模式
- (void)setInterfaceStyleIsDarkModel:(BOOL)isDarkModel{
    if (@available(iOS 13.0, *)) {
        if (isDarkModel) {
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }else{
            self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
    } else {
        // Fallback on earlier versions
    }
}
/// 暗黑模式改变的回调代理
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            BOOL isDarkModel = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
            if (self.InterfaceStyleDidChangeBlock) {
                self.InterfaceStyleDidChangeBlock(isDarkModel);
            }
        }
    }
}

/// 分页请求方法(带有上拉刷新)
- (__kindof NSURLSessionDataTask *)GETPage:(NSString *)interface
                                parameters:(nullable id)parameters
                               showLoading:(BOOL)showLoading
                                modelClass:(Class)modelClass
                                   success:(RequestSucceedBlock)requestSuccess
                                   failure:(RequestFailBlock)requestFail{
    //为了只执行一次
    if (self.isHaveGetPageVc == NO) {
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self pages_loadMore];
        }];
        //标记子类的vc具有分页请求
        self.isHaveGetPageVc = YES;
    }
    __weak typeof(self) ws = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setValue:@(self.pageNum) forKey:@"pageNumber"];
    [param setValue:@(self.pageSize) forKey:@"pageSize"];
//    KKLog(@"get分页查询的 param : %@",param);
    NSURLSessionDataTask *tast = [NetWorkTool GET:interface parameters:param showLoading:showLoading success:^(id  _Nonnull responseObject) {
//        KKLog(@"get分页查询的 总条数: %@ 总页码: %@",[responseObject objectForKey:@"total"],[responseObject objectForKey:@"totalPages"]);
        [ws endRefreshState];
        NSArray *data = [modelClass.class zh_modelArrayWithJsonArray:[responseObject objectForKey:@"list"]];
        if (ws.pageNum == 1) {
            [ws.dataSource removeAllObjects];
        }
        [ws.dataSource addObjectsFromArray:data];
        [ws.tableView reloadData];
        if (ws.pageNum == 1) {
            [ws.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        }
        if (data.count < ws.pageSize){
            ws.tableView.mj_footer.hidden = YES;
        }
        requestSuccess(responseObject);
    } failure:^(NSError * _Nonnull error) {
        [ws endRefreshState];
        ws.pageNum -= 1;
        requestFail(error);
    }];
    return tast;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark CollectionView代理方法
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
/// 该方法是设置cell的size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(0, 0);
}
/// 两行之间的最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
/// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
// 该方法是设置一个section的上左下右边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark 懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[ZhTableView alloc] initWithFrame:CGRectZero style:self.tableStyle]; //默认 UITableViewStyleGrouped
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
    }
    return _tableView;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        [flowlayout setScrollDirection:self.layoutDirection];  //默认 UICollectionViewScrollDirectionVertical
        _collectionView = [[ZhCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableDictionary *)vcParam{
    if (_vcParam == nil) {
        _vcParam = [NSMutableDictionary dictionary];
    }
    return _vcParam;
}
- (ZhFooterEmptyView *)footerEmptyView{
    if (_footerEmptyView == nil) {
        _footerEmptyView = [[ZhFooterEmptyView alloc]init];
    }
    return _footerEmptyView;
}


@end
