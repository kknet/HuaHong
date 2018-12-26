//
//  NSTimer+HHTimer.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (HHTimer)
+ (NSTimer *)hhtimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
@end

NS_ASSUME_NONNULL_END
