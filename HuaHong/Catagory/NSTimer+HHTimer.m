//
//  NSTimer+HHTimer.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSTimer+HHTimer.h"

@implementation NSTimer (HHTimer)
+ (NSTimer *)hhscheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(blockHandle:) userInfo:[block copy] repeats:repeats];
}

+ (void)blockHandle:(NSTimer *)timer
{
    void(^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}
@end
