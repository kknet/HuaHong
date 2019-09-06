//
//  NSArray+NSDirectory_Convert_m.m
//  HuaHong
//
//  Created by 华宏 on 2018/11/21.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSArray+NSDirectory_Convert_m.h"

@implementation NSArray (Convert)

- (NSString *)convertToJson
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"NSArray转json失败");
        return @"";
    }
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end

@implementation NSDictionary (Convert)

- (NSString *)convertToJson
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"NSDictionary转json失败");
        return @"";
    }
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}
@end
