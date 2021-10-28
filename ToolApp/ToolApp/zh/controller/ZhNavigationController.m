//
//  ZhNavigationController.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/10/28.
//

#import "ZhNavigationController.h"

@interface ZhNavigationController ()<UINavigationControllerDelegate>

@end

@implementation ZhNavigationController

//设置是否显示状态栏
- (BOOL)prefersStatusBarHidden {
    return self.topViewController.prefersStatusBarHidden;
}
//设置导航栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.topViewController.preferredStatusBarStyle;
}
//设置是否支持的屏幕旋转
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}
//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 隐藏tabbar
    if (self.viewControllers.count > 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
}

@end
