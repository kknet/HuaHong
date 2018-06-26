//
//  User+CoreDataProperties.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/26.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic age;
@dynamic image;
@dynamic name;
@dynamic userID;

@end
