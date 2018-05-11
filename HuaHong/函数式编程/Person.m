//
//  Person.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "Person.h"

@implementation Person

-(instancetype)initWithBlock:(NSString *(^)(NSString *, NSString *))block
{
    
    _fullName = block(@"hua",@"hong");
    return self;
}

-(void)eatWith:(NSString *)objc
{
    NSLog(@"eat:%@",objc);
}

-(void)eat:(NSString *)objc
{
    NSLog(@"Persion eat:%@",objc);
}
@end
