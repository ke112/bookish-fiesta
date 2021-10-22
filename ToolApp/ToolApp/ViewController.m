//
//  ViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//

#import "ViewController.h"
#import "ZHVersionManager.h"
#import "ZHLocation.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ZhLoadingHud.h"
#import "ZhDownloadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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



@end