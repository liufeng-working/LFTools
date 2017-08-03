//
//  NSDate+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

/*
 y  年
 M  年中的月份
 w  年中的周数
 W  月份中的周数
 D  年中的天数
 d  月份中的天数
 F  月份中的星期
 E  星期中的天数
 a  Am/pm 标记
 H  一天中的小时数（0-23）
 k  一天中的小时数（1-24）
 K  am/pm 中的小时数（0-11）
 h  am/pm 中的小时数（1-12）
 m  小时中的分钟数
 s  分钟中的秒数
 S  毫秒数
 z  时区  GMT-08:00
 Z  时区  RFC 822 time zone  -0800
 */

#import <Foundation/Foundation.h>

@interface NSDate (LFCategory)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;
@property (nonatomic, readonly) NSInteger nanosecond;
@property (nonatomic, readonly) NSInteger weekday;
@property (nonatomic, readonly) NSInteger weekdayOrdinal;
@property (nonatomic, readonly) NSInteger weekOfMonth;
@property (nonatomic, readonly) NSInteger weekOfYear;
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;
@property (nonatomic, readonly) NSInteger quarter;
@property (nonatomic, readonly) BOOL isLeapMonth;
@property (nonatomic, readonly) BOOL isLeapYear;

/**
 *  获取当前时间（东八区）
 */
+ (NSDate *)currentDate;

/**
 *  时间字符串（20160804033650）
 */
- (NSString *)timeString;

/**
 *  根据指定格式输出时间字符串
 */
- (NSString *)stringFromDateFormatter:(NSString *)formatter;

/**
 *  根据指定格式，从指定字符串获取时间
 */
+ (NSDate *)dateFromDateFormatter:(NSString *)formatter andString:(NSString *)string;

/**
 *  获取操作日历的实例
 */
+ (NSDateComponents *)componentsWithStartDate:(NSDate *)startDate toDate:(NSDate *)resultDate;

/**
 *  获取指定时间前几天的日期
 */
- (NSDate *)earlyDayWithCount:(NSInteger)dayCount;

/**
 *  获取指定时间后几天的日期
 */
- (NSDate *)lateDayWithCount:(NSInteger)dayCount;

/**
 *  获取指定时间前几月的日期
 */
- (NSDate *)earlyMonthWithCount:(NSInteger)monthCount;

/**
 *  获取指定时间后几月的日期
 */
- (NSDate *)lateMonthWithCount:(NSInteger)monthCount;

/**
 *  获取指定时间前几年的日期
 */
- (NSDate *)earlyYearWithCount:(NSInteger)yearCount;

/**
 *  获取指定时间后几年的日期
 */
- (NSDate *)lateYearWithCount:(NSInteger)yearCount;

/**
 *  判断是不是当年
 */
- (BOOL)isCurrentYear;

/**
 *  判断是不是同一年的同一个月
 */
- (BOOL)isCurrentMonth;

/**
 *  判断是不是当天
 */
- (BOOL)isCurrentDay;

/**
 *  获得某个时间的时间戳
 */
- (NSTimeInterval)timeInterval;

/**
 *  通过时间戳得出时间
 */
+ (NSDate *)dateFromTimeInterval:(NSTimeInterval)time;

/**
 *  两个时间的差值
 */
+ (NSString *)dateFromTimeInterval:(NSTimeInterval)from
                    toTimeInterval:(NSTimeInterval)to;
- (NSString *)dateToCurrentDate:(NSDate *)currentDate;

@end

@interface NSDate (difference)

/**
 与当前时间相差的秒数
 
 @return 秒数
 */
- (NSInteger)difference;

@end
