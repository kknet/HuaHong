//
//  Factory.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "Factory.h"

@implementation Factory

- (Flower *)flowerWithType:(FlowerType)type
{
    if (_flowerPools == nil) {
        _flowerPools = [[NSMutableDictionary alloc]initWithCapacity:kTotalColors];
    }
    
    Flower *flower = [_flowerPools objectForKey:[NSNumber numberWithInt:type]];
    if (flower == nil) {
        flower = [[Flower alloc]init];
        switch (type) {
            case kRedColor:
                flower.name = @"红花";
                break;
            case kBlueColor:
                flower.name = @"蓝花";
                break;
            case kYellowColor:
                flower.name = @"黄花";
                break;
                
            default:
                break;
        }
        
        [_flowerPools setObject:flower forKey:[NSNumber numberWithInt:type]];
    }
    return flower;
}

@end
