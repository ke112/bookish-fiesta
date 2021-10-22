//
//  NSDate+ZhExt.m
//  OriginalPro
//
//  Created by zhangzhihua on 2019/2/14.
//  Copyright © 2019 zhangzhihua. All rights reserved.
//

#import "NSDate+ZhExt.h"

@implementation NSDate (ZhExt)

+ (long)zh_getNowTimeStamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    return (long)[date timeIntervalSince1970]*1000;
}

+ (NSString *)zh_getDateStrWithSec:(long)sec dateFormat:(NSString *)dateFormat{
    NSString *secStr = [NSString stringWithFormat:@"%ld",sec];
    long ffsec = secStr.length == 10 ? sec : sec/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ffsec];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT"];
    format.timeZone = zone;
    [format setDateFormat:dateFormat];
    return [format stringFromDate:date];
}
+ (long)zh_getSecWithDateStr:(NSString *)dateStr dateFormat:(NSString *)dateFormat{
    long time;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT"];
    format.timeZone = zone;
    [format setDateFormat:dateFormat];
    NSDate *fromdate = [format dateFromString:dateStr];
    time = (long)[fromdate timeIntervalSince1970];
    return time*1000;
}
/// 格式化日期 指定的输出格式
- (NSString *)zh_toStringByformat:(NSString *)dateFormat{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateFormat];
    NSString *returnString = [format stringFromDate:self];
    return returnString;
}

/// 格式化日期 默认的输入格式 @"yyyy-MM-dd HH:mm:ss"
- (NSString *)zh_toString{
    NSString *format = @"yyyy-MM-dd HH:mm:ss";
    return [self zh_toStringByformat:format];
}

/// 根据 字符串格式 转换 字符串为日期
+ (NSDate *)zh_dateByStringFormat:(NSString *)dateFormat dateString:(NSString *)dateString{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateFormat];
    NSDate *date = [format dateFromString:dateString];
    return date;
}

/// 根据 年月日时分秒 返回指定的日期
+ (NSDate *)zh_dateByYear:(NSInteger)year month:(NSInteger)month date:(NSInteger)date hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateObj = [format dateFromString:[NSString stringWithFormat:@"%4ld-%2ld-%2ld %2ld:%2ld:%2ld",(long)year,(long)month,(long)date,(long)hour,(long)minute,(long)second]];
    return dateObj;
}

/// 根据指定时间 和当前时间 相比后的时间描述
+ (NSString *)zh_compareCurrentTime:(NSDate *)compareDate{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <=3){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        result = [compareDate zh_toStringByformat:@"yyyy-MM-dd"];
    }
    
    return  result;
}

/// 获取NSDate的年份部分
+ (NSInteger)zh_getFullYear:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSString *yearStr = [format stringFromDate:date];
    return atoi([yearStr UTF8String]);
}

/// 获取NSDate的月份部分
+ (NSInteger)zh_getMonth:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    NSString *monthStr = [format stringFromDate:date];
    return atoi([monthStr UTF8String]);
}
/// 获取NSDate的日期部分
+ (NSInteger)zh_getDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd"];
    NSString *dateStr = [format stringFromDate:date];
    return atoi([dateStr UTF8String]);
}
/// 获取NSDate的小时部分
+ (NSInteger)zh_getHour:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH"];
    NSString *hourStr=[format stringFromDate:date];
    return atoi([hourStr UTF8String]);
}
/// 获取NSDate的分钟部分
+ (NSInteger)zh_getMinute:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format dateFromString:@"mm"];
    NSString *minuteStr=[format stringFromDate:date];
    return atoi([minuteStr UTF8String]);
}
/// 获取NSDate的秒部分
+ (NSInteger)zh_getSecond:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format dateFromString:@"ss"];
    NSString *secondStr=[format stringFromDate:date];
    return atoi([secondStr UTF8String]);
}

/// 获取当前时间的: 前一周(day:-7)丶前一个月(month:-30)丶前一年(year:-1)的时间戳
+ (NSString *)zh_getExpectTimestampYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day andFormatter:(NSString *)dateFormat{
    
    NSDate *currentdata = [NSDate date];
    // NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:year?:0];
    [datecomps setMonth:month?:0];
    [datecomps setDay:day?:0];
    // dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdata options:0];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    if (dateFormat.length>0) {
        [format setDateFormat:dateFormat];
    } else {
        [format setDateFormat:@"yyyy-MM-dd"];
    }
    //预算的时间日期
    NSString *calculateStr = [format stringFromDate:calculatedate];
    return calculateStr;
}

@end
