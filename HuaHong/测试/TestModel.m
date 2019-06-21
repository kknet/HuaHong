//
//  TestModel.m
//  HuaHong
//
//  Created by 华宏 on 2019/5/10.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        [self setValuesForKeysWithDictionary:dict];
        
       
        self.second = [[SecondModel alloc]initWithDict:dict[@"second"]];
        
        
    }
    
    return self;
}

@end

@implementation SecondModel

@end
