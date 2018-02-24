//
//  NSArray+Log.m
//  9.Dictionary
//
//  Created by keyzhang on 15-1-24.
//  Copyright (c) 2015年 无限互联3G学院 www.iphonetrain.com. All rights reserved.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *strM = [NSMutableString stringWithString:@"\n(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [strM appendFormat:@"\t\"%@\",\n", obj];
        }else
        {
            [strM appendFormat:@"\t%@,\n", obj];
        }
        
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *strM = [NSMutableString stringWithString:@"\n{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [strM appendFormat:@"\t\"%@\" : \"%@\",\n", key, obj];
        }else
        {
            [strM appendFormat:@"\t\"%@\" : %@,\n", key, obj];
        }
        
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end

