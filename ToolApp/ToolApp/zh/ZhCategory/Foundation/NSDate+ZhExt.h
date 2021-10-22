//
//  NSDate+ZhExt.h
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZhExt)

/// 获取现在的时间戳
+ (long)zh_getNowTimeStamp;

/// 根据 时间戳 ->字符串
+ (NSString *)zh_getDateStrWithSec:(long)sec dateFormat:(NSString *)dateFormat;

/// 根据 时间字符串 -> 时间戳
+ (long)zh_getSecWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat;

/// 格式化日期 指定的输出格式
- (NSString *)zh_toStringByformat:(NSString *)dateFormat;

/// 格式化日期 默认的输入格式 @"yyyy-MM-dd HH:mm:ss"
- (NSString *)zh_toString;

/// 根据 字符串格式 转换 字符串为日期
+ (NSDate *)zh_dateByStringFormat:(NSString *)dateFormat dateString:(NSString *)dateString;

/// 根据 年月日时分秒 返回指定的日期
+ (NSDate *)zh_dateByYear:(NSInteger)year month:(NSInteger)month date:(NSInteger)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/// 根据指定时间 和当前时间 相比后的时间描述
+ (NSString *)zh_compareCurrentTime:(NSDate *)compareDate;

/// 获取NSDate的年份部分
+ (NSInteger)zh_getFullYear:(NSDate *)date;

/// 获取NSDate的月份部分
+ (NSInteger)zh_getMonth:(NSDate *)date;

/// 获取NSDate的日部分
+ (NSInteger)zh_getDate:(NSDate *)date;

/// 获取NSDate的小时部分
+ (NSInteger)zh_getHour:(NSDate *)date;

/// 获取NSDate分钟部分
+ (NSInteger)zh_getMinute:(NSDate *)date;

/// 获取NSDate的秒数部分
+ (NSInteger)zh_getSecond:(NSDate *)date;

//; 获取当前时间的: 前一周(day:-7)丶前一个月(month:-30)丶前一年(year:-1)的时间戳
+ (NSString *)zh_getExpectTimestampYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day andFormatter:(NSString *)dateFormat;


@end

NS_ASSUME_NONNULL_END
