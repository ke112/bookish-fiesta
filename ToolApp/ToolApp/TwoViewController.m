//
//  TwoViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/10/26.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "ThreeViewController.h"
#import "TwoViewController.h"
#import "FourViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"3";
    self.backgroundColor = UIColor.greenColor;
    self.naviBarColor = UIColor.systemPinkColor;
    [self updateStatusBarStyleDark:NO];
//    [self updateStatusBarHidden:YES];
    [self updateNaviBarHidden:YES];
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(100, 200, 60, 20);
}
- (void)testClick{
    [self.navigationController pushViewController:[ThreeViewController new] animated:YES];
}

@end
