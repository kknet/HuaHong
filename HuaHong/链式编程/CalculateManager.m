//
//  CalculateManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CalculateManager.h"

@implementation CalculateManager


-(CalculateManager *(^)(int value))add
{
    return ^(int value){
        _result += value;
        
        return self;
    };
}

//-(instancetype)add:(int)value
//{
//    _result += value;
//    return self;
//}
@end
