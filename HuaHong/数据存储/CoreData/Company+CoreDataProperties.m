//
//  Company+CoreDataProperties.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "Company+CoreDataProperties.h"

@implementation Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Company"];
}

@dynamic name;
@dynamic user;

@end
