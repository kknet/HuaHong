//
//  City+CoreDataProperties.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"City"];
}

@dynamic cityId;
@dynamic cityName;
@dynamic company;

@end
