//
//  OneViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/10/26.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "ThreeViewController.h"
#import "TwoViewController.h"
#import "FourViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"2";
    self.backgroundColor = UIColor.redColor;
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testBtn setTitle:@"testBtn" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    testBtn.frame = CGRectMake(100, 200, 60, 20);
}
- (void)testClick{
    [self.navigationController pushViewController:[TwoViewController new] animated:YES];
}

@end
