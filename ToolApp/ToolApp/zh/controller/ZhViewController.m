//
//  ZhViewController.m
//  GoodLife_New
//
//  Created by hshs on 2021/1/5.
//  Copyright © 2021 好生活. All rights reserved.
//

#import "ZhViewController.h"
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

@interface ZhViewController ()
/// 子类vc是否有分页请求
@property (nonatomic, assign) BOOL isHaveGetPageVc;


@end

@implementation ZhViewController

- (void)dealloc{
    NSLog(@"\nvc类 %@ 销毁了\n",NSStringFromClass([self class]));
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.NaviBarLineHide) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.disableSideslip;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithHex(@"0xF5F5F5");
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableStyle = UITableViewStyleGrouped;
    self.pageNum = 1;
    self.pageSize = 10;
    
    [self showDefaultBackNaviWithAction];
    
    [self handleNetWork];
    __weak typeof(self) ws = self;
    self.footerEmptyView.refreshDataBlock = ^(ZhEmptyLoadState state) {
        ws.refreshDataBlock(state);
    };
}

/// 处理网络相关问题
- (void)handleNetWork{
    if ([UIDevice zh_isAirPlane]) {
        [ZhAlertTool showAlertWithTitle:@"关闭飞行模式或使用无线局域网来访问数据" message:nil cancel:@"好" sure:@"设置" cancelBlock:^{
            
        } sureBlock:^{
            [ZhSystemTool openAppPrivacySettings];
        }];
    } else {
        if (![UIDevice zh_isNetwork]) {
            [ZhAlertTool showAlertWithTitle:@"打开蜂窝数据或使用无线局域网访问数据" message:nil cancel:@"好" sure:@"设置" cancelBlock:^{
                
            } sureBlock:^{
                [ZhSystemTool openAppPrivacySettings];
            }];
        }else{
            NSLog(@"正常有网");
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
        emptyView.backgroundColor = kColorWithHex(0xF5F5F5);
        
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

#pragma mark ====== FooterView管理EmptyView ======
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


- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.view.backgroundColor = bgColor;
    self.tableView.backgroundColor = bgColor;
    self.collectionView.backgroundColor = bgColor;
}

/// 设置导航栏标题
- (UILabel *)setTitleStr:(NSString *)title{
    self.title = title;
    UILabel *titleLb = [[UILabel alloc]init];
    titleLb.frame = CGRectMake(0, 0, 200, 44);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLb.textColor = kColorWithHex(0x2c2c2c);
    titleLb.text = title;
    [titleLb sizeToFit];
    self.navigationItem.titleView = titleLb;
    return titleLb;
}

/// 设置titleview
- (UIView *)setTitleView:(UIView *)titleView{
    titleView.frame = CGRectMake(40, (44-35)/2, kScreenWidth-80, 35);
    self.navigationItem.titleView = titleView;
    return titleView;
}

- (UIButton *)showDefaultBackNaviWithAction{
    return [self showDefaultBackNaviWithAction:@selector(backBtnclick)];
}
- (UIButton *)showWhiteBackNaviWithAction{
    return [self setLeftNavWithImage:@"common_back_FFF_icon" target:self action:@selector(backBtnclick)];
}
- (UIButton *)showDefaultBackNaviWithAction:(SEL)action{
    return [self setLeftNavWithImage:@"project_back" target:self action:action];
}
- (UIButton *)showWhiteBackNaviWithAction:(SEL)action{
    return [self setLeftNavWithImage:@"common_back_FFF_icon" target:self action:action];
}

- (UIButton *)setLeftNavWithImage:(NSString *)image target:(id)target action:(SEL)action{
    UIBarButtonItem *base_leftBtn = [UIBarButtonItem zh_itemWithImage:image target:target action:action];
    self.navigationItem.leftBarButtonItem = base_leftBtn;
    return (UIButton *)base_leftBtn.customView;
}
- (UIButton *)setLeftNavWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *base_leftBtn = [UIBarButtonItem zh_itemWithTitle:title target:target action:action];
    self.navigationItem.leftBarButtonItem = base_leftBtn;
    return (UIButton *)base_leftBtn.customView;
}
- (UIButton *)setRightNavWithImage:(NSString *)image target:(id)target action:(SEL)action{
    UIBarButtonItem *base_rightBtn = [UIBarButtonItem zh_itemWithImage:image target:target action:action];
    self.navigationItem.rightBarButtonItem = base_rightBtn;
    return (UIButton *)base_rightBtn.customView;
}
- (UIButton *)setRightNavWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIBarButtonItem *base_rightBtn = [UIBarButtonItem zh_itemWithTitle:title target:target action:action];
    self.navigationItem.rightBarButtonItem = base_rightBtn;
    return (UIButton *)base_rightBtn.customView;
}
- (void)setRightNavWithImages:(NSArray<NSString *> *)images target:(id)target action:(SEL)action andAction:(SEL)andAction{
    
    UIBarButtonItem *base_rightBtnOne = [UIBarButtonItem zh_itemWithImage:[images firstObject] target:target action:action];
    UIBarButtonItem *base_rightBtnTwo = [UIBarButtonItem zh_itemWithImage:[images lastObject] target:target action:action];
    self.navigationItem.rightBarButtonItems = @[base_rightBtnOne,base_rightBtnTwo];
}

#pragma mark - 返回点击事件
- (void)backBtnclick{
    NSInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.view endEditing:YES];
}
/**基类返回按钮方法  没有动画效果*/
- (void)goBackNoAnimation{
    NSInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    [self.view endEditing:YES];
}

- (void)hideDefaultBackNavi{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}
- (void)hideRightNaviButton{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)setNavi{
    
}
- (void)setUI{
    
}
- (void)setData{
    
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

/// 设置当前控制器是否为暗黑模式
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
    KKLog(@"get分页查询的 param : %@",param);
    NSURLSessionDataTask *tast = [NetWorkTool GET:interface parameters:param showLoading:showLoading success:^(id  _Nonnull responseObject) {
        KKLog(@"get分页查询的 总条数: %@ 总页码: %@",[responseObject objectForKey:@"total"],[responseObject objectForKey:@"totalPages"]);
        [ws endRefreshState];
        NSArray *data = [modelClass.class zh_modelArrayWithJsonArray:[responseObject objectForKey:@"list"]];
        if (ws.pageNum == 1) {
            [ws.dataArray removeAllObjects];
        }
        [ws.dataArray addObjectsFromArray:data];
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
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return self.dataArray.count;
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
    return self.dataArray.count;
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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