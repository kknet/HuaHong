//
//  Model.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "Model.h"

@implementation Model

/*
 将某个对象写入文件时候调用
 在这个方法中说清楚哪些属性需要存储
 */
//-(void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:_name forKey:@"name111"];
//    [aCoder encodeInteger:_age forKey:@"age"];
//}


/*
 
 解析数据会调用这个方法
 需要解析哪些属性
 
 */
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        _name = [aDecoder decodeObjectForKey:@"name111"];
//        _age = [aDecoder decodeIntegerForKey:@"age"];
//    }
//    return self;
//}

- (id)copyWithZone:(NSZone *)zone
{
    Model *model = [[[self class]allocWithZone:zone]init];
    model.name = self.name;
    model.age = self.age;
    
    //未公开的成员
    model->_userID = _userID;
//    [model setValue:_userID forKey:@"userID"];
    
    return model;
}


//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    Model *model = [[[self class]allocWithZone:zone]init];
//    model.name = self.name;
//    model.age = self.age;
//
//    //未公开的成员
//    [model setValue:_userID forKey:@"userID"];
//
//    return model;
//}

@end
