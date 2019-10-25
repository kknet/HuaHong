//
//  BaseModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding,NSCopying,NSMutableCopying>

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)parserModelWithDictionary:(NSDictionary *)dictionary;

//测试
@property (nonatomic,copy)   NSString *userName;
@property (nonatomic,assign) NSInteger age;

@end
