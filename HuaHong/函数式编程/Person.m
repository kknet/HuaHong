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

/*--------------------------------------------------------------------*/
- (nonnull Person *)run1
{
    NSLog(@"run1");
    return self;
}

- (Person * _Nonnull (^)(void))run2
{
    Person *(^runBlock)(void) = ^Person *(){
        NSLog(@"run2");
        return self;
    };
    
    return runBlock;
}

- (Person * _Nonnull (^)(float distance))run3
{
    return ^ Person * (float distance) {
        NSLog(@"跑了 %.0f 米", distance);
        
        return self;
    };
}
@end
