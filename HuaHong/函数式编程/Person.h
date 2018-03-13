//
//  Person.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(copy,nonatomic)NSString *fullName;

-(instancetype)initWithBlock:(NSString *(^)(NSString *firstName,NSString *lastName))block;

-(void)eatWith:(NSString *)objc;
@end
