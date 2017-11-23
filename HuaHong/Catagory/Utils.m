//
//  Utils.m
//  SinaWeibo
//
//  Created by wang xinkai on 15/4/13.
//  Copyright (c) 2015年 wxk. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSString*)formatString:(NSString*)timeString{
    
    
    
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *date = [self dateFromString:timeString formate:formate];
    
    NSTimeInterval time = [[NSDate new] timeIntervalSinceDate:date];
    
//    如果小于一天
    if (time<24*60*60) {
        
        if (time<60*60) {
            
            
            return [NSString stringWithFormat:@"%d分钟前",(int)time/60];
        }
        
        return [NSString stringWithFormat:@"%d小时前",(int)time/60/60];
        
    }
    
    
    return [self stringFromDate:date formate:@"MM-dd HH:mm"];
}


+(NSDate *)dateFromString:(NSString *)timeString formate:(NSString*)formate{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return  [formatter dateFromString:timeString];
}


+(NSString *)stringFromDate:(NSDate *)date formate:(NSString*)formate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return  [formatter stringFromDate:date];
}

@end
