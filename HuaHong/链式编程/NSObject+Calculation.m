//
//  NSObject+Calculation.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSObject+Calculation.h"

@implementation NSObject (Calculation)

+(int)Calculate:(void(^)(CalculateManager *manager))block
{
    CalculateManager *manager = [CalculateManager new];
    block(manager);
    
    return manager.result;
}
@end
