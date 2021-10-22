//
//  ZhTimerManage.h
//  
//
//  Created by zhangzhihua on 2021/6/23.
//  计时器工具
#define ZhTimer [ZhTimerManage shared]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhTimerManage : NSObject

/// 单例对象
+ (instancetype)shared;
/// 单例销毁
+ (void)teardown;

#pragma mark ====== 方法,属性 ======
/// 延迟执行,默认为0(秒)
@property (nonatomic, assign) CGFloat afterDelay;
/// 触发间隔,默认为1(秒)
@property (nonatomic, assign) CGFloat interval;
/// 开启
- (void)start;
/// 停止
- (void)stop;
/// 实时回调
@property (nonatomic, copy) void (^runBlock)(CGFloat runTime);

#pragma mark ====== 拓展 ======
/// 开始时的时间戳(秒)
@property (nonatomic, assign) NSTimeInterval startTime;
/// 上一次的时间戳(秒)
@property (nonatomic, assign) NSTimeInterval lastTime;
/// 总共执行时间秒数(秒)
@property (nonatomic, assign) CGFloat runTime;
/// 最大可执行时间秒数,到期停止(秒)
@property (nonatomic, assign) CGFloat maxRunTime;
/// 是否已经开启了
@property (nonatomic, assign) BOOL isStarted;



@end

NS_ASSUME_NONNULL_END
