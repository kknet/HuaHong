//
//  NSDate+Category.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

/** String转NSDate */
+(NSDate *)dateFromString:(NSString *)timeString formate:(NSString*)formate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    return  [formatter dateFromString:timeString];
}

/** NSDate转String */
+(NSString *)stringFromDate:(NSDate *)date formate:(NSString*)formate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    return  [formatter stringFromDate:date];
}

/** 将时间间隔转成Date，如果是毫秒，还要除以1000 */
+(NSDate*)dateWithInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}

/** 将时间间隔转成 时-分-秒 */
+ (NSString *)formartTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    
    long temp = timeInterval;
    NSString *time;
    NSUInteger hour = (NSUInteger)(temp / 3600);
    NSUInteger minute = (NSUInteger)(temp % 3600 / 60);
    NSUInteger second = (NSUInteger)(temp % 3600 % 60);
    
    if (timeInterval < 60) {
        
        time = [NSString stringWithFormat:@"%lu秒",(unsigned long)second];
    }else if(hour <= 0){
        time = [NSString stringWithFormat:@"%lu分%lu秒",(unsigned long)minute,(unsigned long)second];
    }else
    {
        
        time = [NSString stringWithFormat:@"%lu小时%lu分%lu秒",(unsigned long)hour,(unsigned long)minute,(unsigned long)second];
    }
    
    return  time;
}

/** 获取当前时间 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
    return [formatter stringFromDate:[NSDate date]];
}

//获取几个月之后的日期
- (NSDate *)dateAfterMonths:(NSInteger)gapMonthCount {
    //获取当年的月份，当月的总天数
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitCalendar fromDate:self];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSString *dateStr = @"";
    NSInteger endDay = 0;//天
    NSDate *newDate = [NSDate date];//新的年&月
    
    newDate = [formatter dateFromString:dateStr];
    //新月份的天数
    NSInteger newDays = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:newDate].length;
    
    endDay = MIN(newDays, components.day);
    
    //判断是否是下一年
    if (components.month+gapMonthCount > 12)
    {
        //是下一年
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year+(components.month+gapMonthCount)/12,(components.month+gapMonthCount)%12,endDay];
    } else {
        //依然是当前年份
        dateStr = [NSString stringWithFormat:@"%zd-%zd-%zd",components.year,components.month+gapMonthCount,endDay];
    }
    
    newDate = [formatter dateFromString:dateStr];
    return newDate;
}


//判断是否是月末
- (BOOL)isEndOfTheMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSInteger daysInMonth = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSDateComponents *componets = [calendar components:NSCalendarUnitDay fromDate:date];
    if (componets.day >= daysInMonth) {
        return YES;
    }
    return NO;
}

+(NSString *)weekdayStringFromDate:(NSDate *)date
{
    //components.weekday[1,7]对应[周日～周六]，没有0
   NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    //NSCalendarIdentifierGregorian公历
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc]initWithName:@"zh_CN"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:components.weekday];
}
@end
