//
//  Service+CoreDataProperties.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "Service+CoreDataProperties.h"

@implementation Service (CoreDataProperties)

+ (NSFetchRequest<Service *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Service"];
}

@dynamic serviceId;
@dynamic serviceName;
@dynamic company;

@end
