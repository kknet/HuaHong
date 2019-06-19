//
//  NSDate+Category.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Category)

/**
 String转NSDate
 
 @param dateString 日期字符串
 @param format 日期格式
 @return NSDate
 */
+(nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 String转NSDate
 
 @param dateString 日期字符串
 @param format 日期格式
 @param locale 地区
 @param timeZone 时区
 @return NSDate
 */
+(nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

/**
 NSDate转String
 
 @param format 日期格式
 @return 日期字符串
 */
- (nullable NSString *)stringWithFormat:(NSString *)format;

/**
 NSDate转String
 
 @param format 日期格式
 @param locale 地区
 @param timeZone 时区
 @return 日期字符串
 */
- (nullable NSString *)stringWithFormat:(NSString *)format locale:(NSLocale *)locale timeZone:(NSTimeZone *)timeZone;

/** 将时间间隔转成Date，如果是毫秒，还要除以1000 */
+(NSDate*)dateWithInterval:(NSTimeInterval)timeInterval;

/** 将时间间隔转成 时-分-秒 */
+ (NSString *)formartTimeWithTimeInterval:(NSTimeInterval)timeInterval;

/** 获取当前时间 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)format;

//获取几个月之后的日期
- (NSDate *)dateAfterMonths:(NSInteger)gapMonthCount;

@end

NS_ASSUME_NONNULL_END
