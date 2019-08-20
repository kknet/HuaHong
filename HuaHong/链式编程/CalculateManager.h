//
//  CalculateManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateManager : NSObject

@property (nonatomic, assign) int result;

//-(instancetype)add:(int)value;

-(CalculateManager *(^)(int value))add;


@end
