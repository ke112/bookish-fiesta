//
//  FourViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/10/26.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "ThreeViewController.h"
#import "TwoViewController.h"
#import "FourViewController.h"

@interface FourViewController ()

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"5";
//    self.disableSideslip = YES;
    self.backgroundColor = UIColor.yellowColor;
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(100, 200, 260, 20);
    
    NSInteger num = arc4random_uniform(19);
    [testBtn setTitle:[NSString stringWithFormat:@"testBtn %ld",num] forState:UIControlStateNormal];
    
    UIView *blackV = [[UIView alloc]init];
    blackV.backgroundColor = UIColor.blackColor;
    [self.view addSubview:blackV];
    blackV.frame = CGRectMake(0, kNavAndStatusHight, 100, 100);
}
- (void)testClick{
//    [self.navigationController pushViewController:[OneViewController new] animated:YES];
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        KKLog(@"开始前vc : %@",vc);
//    }
//    KKLog(@"");
//#import "ViewController.h"  1  灰
//#import "OneViewController.h"  2  红
//#import "TwoViewController.h"  3  绿
//#import "ThreeViewController.h" 4  蓝
//#import "FourViewController.h"  5  黄
//    [self zh_deleteClass:@[@"OneViewController",@"ThreeViewController"] complete:^{
//        for (UIViewController *vc in self.navigationController.viewControllers) {
//            KKLog(@"vc : %@",vc);
//        }
//    }];
//    [self zh_pushOnceClass:[FourViewController new] animated:YES];
//    [self zh_pushFromClass:@"OneViewController" toClass:[FourViewController new] animated:YES];
//    [self zh_pushUpCount:2 toClass:[OneViewController new] animated:YES];
//    [self zh_pushFromRootCount:1 toClass:[TwoViewController new] animated:YES];
//    [self zh_pushFromRootToClass:[TwoViewController new] animated:YES];
    [self zh_popToClass:@"OneViewController" animated:YES];
    
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        KKLog(@"结束了vc : %@",vc);
//    }
}

@end
