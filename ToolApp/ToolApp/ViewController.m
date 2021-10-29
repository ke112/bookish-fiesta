//
//  ViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//
#define kindex self.navigationController.viewControllers.count

#import "ViewController.h"
#import "ZHVersionManager.h"
#import "ZHLocation.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZhLoadingHud.h"
#import "ZhDownloadManager.h"
#import "UIViewController+ZhNavigation.h"

#import "OneViewController.h"
#import "ThreeViewController.h"
#import "TwoViewController.h"
#import "FourViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *sel;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = [NSString stringWithFormat:@"导航栏 %ld",kindex];
    self.title = @"1";
    self.backgroundColor = UIColor.whiteColor;
    self.naviBarColor = UIColor.yellowColor;
//    self.naviTitleColor = UIColor.redColor;
//    self.naviTitleFont = [UIFont systemFontOfSize:15];
//    self.naviItemColor = UIColor.blackColor;
    
    UILabel *lb = [[UILabel alloc]init];
    lb.text = @"222";
    [self.view addSubview:lb];
    lb.frame = CGRectMake(100, 100, 100, 100);
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(100, 200, 60, 20);
    
    UIButton *testBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn2 setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn2 setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn2 addTarget:self action:@selector(testClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn2];
    testBtn2.frame = CGRectMake(100, 240, 60, 20);
    
    UIButton *testBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn3 setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn3 setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn3 addTarget:self action:@selector(testClick3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn3];
    testBtn3.frame = CGRectMake(100, 280, 60, 20);
    
    UIButton *testBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn4 setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn4 setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn4 addTarget:self action:@selector(testClick4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn4];
    testBtn4.frame = CGRectMake(100, 320, 60, 20);
    
    UIButton *testBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn5 setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn5 setTitleColor:UIColor.purpleColor forState:UIControlStateNormal];
    [testBtn5 addTarget:self action:@selector(testClick5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn5];
    testBtn5.frame = CGRectMake(100, 360, 60, 20);
    
//    [[ZHLocation shardLocationManger] beginUpdatingLocationSuccess:^(ZHLocationModel *locationObj) {
//        KKLog(@"country %@",locationObj.debugDescription);
////        KKLog(@"%@%@%@%@%@%@",
////              locationObj.country,
////              locationObj.administrativeArea,
////              locationObj.locality,
////              locationObj.subLocality,
////              locationObj.thoroughfare,
////              locationObj.name);
//        //中国河北省廊坊市霸州市迎宾东道与益津中路交汇处霸州市人民政府
//    } failure:^(NSError *error) {
//
//    }];
    
//    [[ZHVersionManager versionDetection] requestVersionUpdateQueryWithAppleId:@"1225446103" promptType:WYVersionPromptIgnore cycle:7 isShowUpdateContent:NO];
}

- (void)testClick{
    [ZhLoadingHud showHint:@"参数错误sdfsdfsdfsdfsdfsdfsdsdfsdfdsfsdfsdf" addedTo:self.view];
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(1.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhLoadingHud showHudWithHint:@"参数参数错误参数参数错误参数参数错误参数参数错误参数参数错误" addedTo:self.view];
        });
        NSLog(@"2");
    });
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(2.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhLoadingHud showHint:@"参数参数参数错误" addedTo:self.view];
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(3.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhLoadingHud showHudWithImage:@"pulish_success" hint:@"测试返回" addedTo:self.view];
        });
    });
    
    NSLog(@"5");
}
- (void)testClick2{
    [ZhLoadingHud showHudWithImage:@"pulish_success" hint:@"发表成功" addedTo:self.view yOffset:0];
}
- (void)testClick3{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    hud.label.text = @"正在加载...";
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(1.);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
}
- (void)testClick4{
    NSString *url = @"http://download.lingyongqian.cn//music//ForElise.mp3";
    [[ZhDownloadManager manager] deleteWithUrl:url];
    [[ZhDownloadManager manager] download:url progress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, CGFloat progress) {
        NSLog(@"progress: %f",progress);
        [ZhLoadingHud showHudWithProgress:progress hint:@"下载中..." addedTo:nil];
    } state:^(ZhDownloadState state, NSString *file, NSError *error) {
        
    }];
}

- (void)testClick5{
////    if (kindex == 2) {
////        BOOL mode = [self zh_viewControllerIsPushedShow];
////        if (mode) {
////            KKLog(@"push mode : %ld",mode);
////        } else {
////            KKLog(@"present mode : %ld",mode);
////        }
////
////    }else
//    if (kindex == 5) {
////        [self zh_deleteClass:@[@"ViewController"] complete:^{
////            KKLog(@"删完了");
////        }];
////        [self zh_pushOnceClass:[ViewController new] animated:YES];
////        [self zh_pushFromClass:@"ViewController" toClass:[ViewController new] animated:YES];
////        [self zh_pushUpCount:2 toClass:[ViewController new] animated:YES];
//        [self zh_pushFromRootCount:2 toClass:[ViewController new] animated:YES];
//
//    }else{
//
//    }
//    [self.navigationController pushViewController:[OneViewController new] animated:YES];
    //@[@"好吃的",@"好玩的",@"好喝的"]
//    [ZhAlertTool showPickerWithOptions:@[@"好吃的",@"好玩的",@"好喝的"] sectionTitle:@"请挑选吃的" lastSel:_sel select:^(NSInteger selectIndex, NSString * _Nullable selectStr) {
//        _sel = selectStr;
//    }];
//    [ZhAlertTool showAlertWithTitle:@"你错了吗" doneTitle:@"错了" doneClick:^{
//        NSLog(@"点了确定");
//    }];
    
//    [ZhAlertTool showAlertWithTitle:@"你错了吗" message:nil doneTitle:@"错了" sureBlock:^{
//        NSLog(@"点了确定");
//    } cancelTitle:@"没错" cancelBlock:^{
//        NSLog(@"点了取消");
//    }];
    
}

@end
