//
//  ZhAppTool.m
//  ToolApp
//
//  Created by zhangzhihua on 2021/11/23.
//

#import "ZhAppTool.h"

@implementation ZhAppTool

/// 窗口主视图
+ (UIWindow *)keyWindow{
    UIWindow *window;
    if (@available(iOS 13.0, *)) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }else {
        window = [[UIApplication sharedApplication].delegate window];
    }
    return window;
}

/// appDelegate
+ (AppDelegate *)appDelegate{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return delegate;
}

@end
