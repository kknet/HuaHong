//
//  NSArray+NSDictionary_Log.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/2.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSArray+NSDictionary_Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *strM = [NSMutableString stringWithString:@"\n\t[\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [strM appendFormat:@"\t\"%@\",\n", obj];
        }else
        {
            [strM appendFormat:@"\t%@,\n", obj];
        }
        
    }];
    
    [strM appendString:@"\t]"];
    
    return strM;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
   __block NSUInteger count = self.count;
    NSMutableString *strM = [NSMutableString stringWithString:@"\n{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (count > 1)
        {
            if ([obj isKindOfClass:[NSString class]]) {
                [strM appendFormat:@"\t\"%@\" : \"%@\",\n", key, obj];
            }else
            {
                [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
            }
        }else
        {
            //最后一个，去掉逗号
            if ([obj isKindOfClass:[NSString class]]) {
                [strM appendFormat:@"\t\"%@\" : \"%@\"\n", key, obj];
            }else
            {
                [strM appendFormat:@"\t\"%@\" : %@\n", key, obj];
            }
        }
        
        
        count--;
        
    }];
    
    [strM appendString:@"}"];
    
    return strM;
}

@end


