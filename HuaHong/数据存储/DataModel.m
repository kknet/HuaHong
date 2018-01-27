//
//  DataModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

/*
 将某个对象写入文件时候调用
 在这个方法中说清楚哪些属性需要存储
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name111"];
    [aCoder encodeInteger:_age forKey:@"age"];
}


/*
 
 解析数据会调用这个方法
 需要解析哪些属性
 
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name111"];
        _age = [aDecoder decodeIntegerForKey:@"age"];
    }
    return self;
}

@end
