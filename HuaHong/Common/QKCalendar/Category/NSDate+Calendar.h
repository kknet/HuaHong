//
//  NSDate+Calendar.h
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calendar)

/**
 *  获得当前 NSDate 对象对应的日子
 */
- (NSInteger)dateDay;

/**
 *  获得当前 NSDate 对象对应的月份
 */
- (NSInteger)dateMonth;

/**
 *  获得当前 NSDate 对象对应的年份
 */
- (NSInteger)dateYear;

/**
 *  获取上个月的某一天（day）的 NSDate 对象
 */
- (NSDate *)previousMonthDate:(NSUInteger)day;

/**
 *  获取当月的某一天（day）的 NSDate 对象
 */
- (NSDate *)currentMonthDate:(NSUInteger)day;

/**
 *  获取下个月的某一天（day）的 NSDate 对象
 */
- (NSDate *)nextMonthDate:(NSUInteger)day;

/**
 *  获得当前 NSDate 对象对应的月份的总天数
 */
- (NSInteger)totalDaysInMonth;

/**
 *  获得当前 NSDate 对象对应月份当月第一天的所属星期
 */
- (NSInteger)firstWeekDayInMonth;

//date对应的星期几
+(NSInteger)weekdayFromDate:(NSDate *)date;

/** String转NSDate */
+(NSDate *)dateFromString:(NSString *)timeString formate:(NSString*)formate;
@end
