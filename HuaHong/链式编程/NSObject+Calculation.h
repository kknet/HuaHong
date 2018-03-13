//
//  NSObject+Calculation.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateManager.h"

@interface NSObject (Calculation)

+(int)Calculate:(void(^)(CalculateManager *manager))block;

@end
