//
//  NSDate+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "NSDate+LFCategory.h"

@implementation NSDate (LFCategory)

- (NSInteger)year
{
    return [[[NSDate calendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month
{
    return [[[NSDate calendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day
{
    return [[[NSDate calendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour
{
    return [[[NSDate calendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute
{
    return [[[NSDate calendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second
{
    return [[[NSDate calendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond
{
    return [[[NSDate calendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday
{
    return [[[NSDate calendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal
{
    return [[[NSDate calendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth
{
    return [[[NSDate calendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear
{
    return [[[NSDate calendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear
{
    return [[[NSDate calendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter
{
    return [[[NSDate calendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth
{
    return [[[NSDate calendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear
{
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

/**
 *  获取当前时间（东八区）
 */
+ (NSDate *)currentDate
{
    NSDate *date = [NSDate date];
    return [NSDate dateWithTimeInterval:8*60*60 sinceDate:date];
}

/**
 *  时间字符串（20160804033650）
 */
- (NSString *)timeString
{
    return [self stringFromDateFormatter:@"yyyyMMddHHmmss"];
}

/**
 *  根据指定格式输出时间字符串
 */

- (NSString *)stringFromDateFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:self];
}

/**
 *  根据指定格式，从指定字符串获取时间
 */
+ (NSDate *)dateFromDateFormatter:(NSString *)formatter andString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:string];
}

/**
 *  获取操作日历的实例
 */
+ (NSDateComponents *)componentsWithStartDate:(NSDate *)startDate toDate:(NSDate *)resultDate
{
    return [[self calendar] components:[self unit] fromDate:startDate toDate:resultDate options:NSCalendarWrapComponents];
}

/**
 *  获取指定时间前几天的日期
 */
- (NSDate *)earlyDayWithCount:(NSInteger)dayCount;
{
    NSCalendar *calendar = [NSDate calendar];
    NSCalendarUnit unit = [NSDate unit];
    NSDateComponents *com = [calendar components:unit fromDate:self];
    com.day -= dayCount;
    return [calendar dateFromComponents:com];
}

/**
 *  获取指定时间后几天的日期
 */
- (NSDate *)lateDayWithCount:(NSInteger)dayCount
{
    return [self earlyDayWithCount:-dayCount];
}

/**
 *  获取指定时间前几月的日期
 */
- (NSDate *)earlyMonthWithCount:(NSInteger)monthCount
{
    NSCalendar *calendar = [NSDate calendar];
    NSCalendarUnit unit = [NSDate unit];
    NSDateComponents *com = [calendar components:unit fromDate:self];
    com.month -= monthCount;
    return [calendar dateFromComponents:com];
}

/**
 *  获取指定时间后几月的日期
 */
- (NSDate *)lateMonthWithCount:(NSInteger)monthCount
{
    return [self lateMonthWithCount:-monthCount];
}

/**
 *  获取指定时间前几年的日期
 */
- (NSDate *)earlyYearWithCount:(NSInteger)yearCount
{
    NSCalendar *calendar = [NSDate calendar];
    NSCalendarUnit unit = [NSDate unit];
    NSDateComponents *com = [calendar components:unit fromDate:self];
    com.year -= yearCount;
    return [calendar dateFromComponents:com];
}

/**
 *  获取指定时间后几年的日期
 */
- (NSDate *)lateYearWithCount:(NSInteger)yearCount
{
    return [self earlyYearWithCount:-yearCount];
}
/**
 *  判断是不是当年
 */
- (BOOL)isCurrentYear
{
    NSDateComponents *components = [NSDate componentsWithStartDate:[NSDate currentDate] toDate:self];
    return components.year == 0 ? YES : NO;
}

/**
 *  判断是不是当月
 */
- (BOOL)isCurrentMonth
{
    NSDateComponents *components = [NSDate componentsWithStartDate:[NSDate currentDate] toDate:self];
    if (components.year == 0  &&
        components.month == 0) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  判断是不是当天
 */
- (BOOL)isCurrentDay
{
    NSDateComponents *components = [NSDate componentsWithStartDate:[NSDate currentDate] toDate:self];
    if (components.year  == 0 &&
        components.month == 0 &&
        components.day   == 0) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  获得某个时间的时间戳
 */
- (NSTimeInterval)timeInterval
{
    return [self timeIntervalSince1970] * 1000;
}

/**
 *  通过时间戳得出时间
 */
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)time
{
    return [self dateWithTimeIntervalSince1970:time / 1000];
}

/**
 根据两个戳转换成可读字符串差值
 */
+ (NSString *)dateFromTimeInterval:(NSTimeInterval)from
                    toTimeInterval:(NSTimeInterval)to
{
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:from/1000];
    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:to/1000];
    return [fromDate dateToCurrentDate:toDate];
}

/**
 *  两个时间的差值
 */
- (NSString *)dateToCurrentDate:(NSDate *)currentDate
{
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:from/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeInterval interval = (to - from)/1000;
    if (interval < 0) {
        return @"穿越了";
    }else if (interval < 10) {
        return @"刚刚";
    }else if (interval < 60) {
        return [NSString stringWithFormat:@"%.f秒前", interval];
    }else if (interval < 60*60) {
        return [NSString stringWithFormat:@"%.f分钟前", interval/60];
    }else if (interval < 60*60*24) {
        return [NSString stringWithFormat:@"%.f小时前", interval/60/60];
    }else if (interval < 60*60*24*2) {
        dateFormatter.dateFormat = @"昨天 HH:mm";
        return [dateFormatter stringFromDate:createDate];
    }else if (interval < 60*60*24*3) {
        dateFormatter.dateFormat = @"前天 HH:mm";
        return [dateFormatter stringFromDate:createDate];
    }else {
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:to/1000];
        NSDateComponents *com = [self.calendar components:NSCalendarUnitYear fromDate:createDate toDate:currentDate options:NSCalendarWrapComponents];
        if (com == 0) {
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            return [dateFormatter stringFromDate:createDate];
        }else {
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            return [dateFormatter stringFromDate:createDate];
        }
    }
}

//获取日历对象
+ (NSCalendar *)calendar
{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

// 获取元素集合
+ (NSCalendarUnit)unit
{
    return (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
}

@end

@implementation NSDate (difference)

/**
 与当前时间相差的秒数
 
 @return 秒数
 */
- (NSInteger)difference
{
    if (!self) { return 0; }
    NSDateComponents *com = [[NSDate calendar] components:NSCalendarUnitSecond fromDate:self toDate:[NSDate date] options:NSCalendarWrapComponents];
    return com.second;
}

@end
