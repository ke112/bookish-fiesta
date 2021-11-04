//
//  ZhWebViewController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/11/1.
//

#import "ZhWebViewController.h"
#import "SuperWebView.h"

@interface ZhWebViewController ()

@property (nonatomic, strong) SuperWebView *webView;

@end

@implementation ZhWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) ws = self;
    self.webView = [[SuperWebView alloc] initWithFrame:self.view.bounds webUrl:self.webUrl localUrlName:nil registerFuncWebToNative:@[] eventBlock:^(NSInteger index, id  _Nonnull param) {
        
    }];
    [self.view addSubview:self.webView];
    self.webView.backForwardListBlock = ^(NSInteger count) {
        if (count == 0) {
            [ws showSingleBackBtn];
        } else {
            [ws showDoubleBackBtns];
        }
    };
    self.webView.titleBlock = ^(NSString * _Nonnull title) {
        ws.navigationItem.title = title;
    };
}

/// 显示1个按钮
- (void)showSingleBackBtn{
    __weak typeof(self) ws = self;
    [self showCustomBackNaviWithAction:^{
        [ws oneClick];
    }];
}
/// 显示2个按钮
- (void)showDoubleBackBtns{
    __weak typeof(self) ws = self;
    NSArray *arr = [self setLeftNavWithImages:@[@"back_style1_black",@""] andAction:^(NSInteger index) {
        
    }];
    UIButton *secondeBtn1 = arr[0];
    [secondeBtn1 addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *secondeBtn2 = arr[1];
    [secondeBtn2 setTitle:@"关闭" forState:UIControlStateNormal];
    [secondeBtn2 setImage:nil forState:UIControlStateNormal];
    [secondeBtn2 addTarget:self action:@selector(twoClick) forControlEvents:UIControlEventTouchUpInside];
    
    secondeBtn1.backgroundColor = kRandomColor;
    secondeBtn2.backgroundColor = kRandomColor;
}

/// 第一个按钮方法
- (void)oneClick{
    if (self.webView.webViewCanBack) {
        //webview goback
    }else{
        [self backEvent];
    }
}
/// 第一个按钮方法
- (void)twoClick{
    [self backEvent];
}


@end
