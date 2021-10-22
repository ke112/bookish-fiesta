//
//  ZhTimerManage.m
//  
//
//  Created by zhangzhihua on 2021/6/23.
//

#import "ZhTimerManage.h"

@interface ZhTimerManage ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ZhTimerManage

/// 单例对象
static id instance = nil;
static dispatch_once_t onceToken;

+ (instancetype)shared{
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/// 单例销毁
+ (void)teardown{
    instance = nil;
    onceToken = 0;
}

/// 计时器开启
- (void)start{
    //销毁已经创建的计时器
    if (self.timer != nil) {
        [self stop];
    }
    //创建一个gcd定时器
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0,0, queue);
    
    //延时启动定时器
    CGFloat afterDelayR = self.afterDelay != 0 ? self.afterDelay : 0;
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterDelayR * NSEC_PER_SEC));
    
    //计时器时间间隔执行一次
    CGFloat intervalR = self.interval != 0 ? self.interval : 1;
    uint64_t interval = (uint64_t)(intervalR * NSEC_PER_SEC);
    
    //设置延迟时间和间隔
    dispatch_source_set_timer(_timer, start, interval, 0);
    
    //设置回调
    dispatch_source_set_event_handler(_timer, ^{
        if (!self.startTime) {
            self.startTime = [[NSDate date] timeIntervalSince1970];
        }
        self.lastTime = [[NSDate date] timeIntervalSince1970];
        self.runTime = self.lastTime - self.startTime;
        if (self.runBlock) {
            self.runBlock(self.runTime);
        }
        //如果设置了最大可执行时间数,停止计时器
        if (self.maxRunTime > 0 && self.runTime >= self.maxRunTime) {
            [self stop];
        }
    });
    //默认暂停的，开启定时器
    dispatch_resume(_timer);
    self.isStarted = YES;
}

/// 计时器停止
- (void)stop{
    self.isStarted = NO;
    if (self.timer != nil) {
        dispatch_cancel(self.timer);
        self.timer = nil;
        self.startTime = 0;
        self.lastTime = 0;
    }
}


@end
