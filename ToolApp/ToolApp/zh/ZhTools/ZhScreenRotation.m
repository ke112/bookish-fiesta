//
//  ZhScreenRotation.m
//  Consultant
//
//  Created by 张志华 on 8/21/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "ZhScreenRotation.h"

@implementation ZhScreenRotation

+ (ZhScreenRotation *)sharedInstance {
    static ZhScreenRotation *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        instance.orientationMask = UIInterfaceOrientationMaskPortrait;  // 默认竖屏
    });
    return instance;
}
#pragma mark - 所有方向
- (void)rotationAllDirection{
    [ZhScreenRotation sharedInstance].orientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    
    NSNumber *orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
}

#pragma mark - 竖屏
- (void)rotationPortrait
{
    [ZhScreenRotation sharedInstance].orientationMask = UIInterfaceOrientationMaskPortrait;
    
    NSNumber *orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
}

#pragma mark - 横屏
- (void)rotationLandscape
{
    [ZhScreenRotation sharedInstance].orientationMask = UIInterfaceOrientationMaskLandscape;
    
    NSNumber *orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
}


@end
