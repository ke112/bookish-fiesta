//
//  AppDelegate.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/7/20.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZHHeader.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];

    
    
    return YES;
}



@end
