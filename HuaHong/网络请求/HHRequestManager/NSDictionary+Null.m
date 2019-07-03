//
//  NSDictionary+Null.m
//  HuaHong
//
//  Created by qk-huahong on 2019/6/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "NSDictionary+Null.h"

@implementation NSDictionary (Null)

//NSDictionary过滤NSNull
-(NSDictionary*)filterNull
{
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    for ( NSString* key in self.allKeys ) {
        
        id value = [self objectForKey:key];
        
        if( [value isKindOfClass:[NSNull class] ] )
        {
            continue;
        }
        
        if( [value isKindOfClass:[NSArray class]] || [value isKindOfClass: [NSMutableArray class]] )
        {
            NSArray *arr = [(NSArray *)value filterNull] ;
            [result setObject:arr forKey:key];
            continue;
        }
        
        if( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* dic = [(NSDictionary *)value filterNull];
            [result setObject:dic forKey:key];
            continue;
        }
        
        [result setObject:value forKey:key];
    }
    
    return result;
}


@end


@implementation NSArray (Null)

//NSArray过滤NSNull
- (NSArray *)filterNull
{
    NSMutableArray* result = [NSMutableArray array];
    
    for ( id value in self ) {
        
        if( [value isKindOfClass:[NSNull class] ] )
        {
            continue;
        }
        
        if( [value isKindOfClass:[NSArray class]] || [value isKindOfClass: [NSMutableArray class]] )
        {
            NSArray *arr = [(NSArray *)value filterNull] ;
            [result addObject:arr];
            continue;
        }
        
        if( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary *dic = [(NSDictionary *)value filterNull];
            [result addObject:dic];
            continue;
        }
        
        [result addObject:value];
    }
    
    return result;
}

@end
