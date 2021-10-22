//
//  ZhScreenRotation.h
//  Consultant
//
//  Created by 张志华 on 8/21/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhScreenRotation : NSObject

+ (ZhScreenRotation *)sharedInstance;

@property (assign, nonatomic) UIInterfaceOrientationMask orientationMask;

#pragma mark - 所有方向
- (void)rotationAllDirection;

#pragma mark - 竖屏
- (void)rotationPortrait;

#pragma mark - 横屏
- (void)rotationLandscape;

@end

NS_ASSUME_NONNULL_END
