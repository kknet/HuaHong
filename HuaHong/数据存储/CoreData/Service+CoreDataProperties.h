//
//  Service+CoreDataProperties.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "Service+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Service (CoreDataProperties)

+ (NSFetchRequest<Service *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *serviceId;
@property (nullable, nonatomic, copy) NSString *serviceName;
@property (nullable, nonatomic, retain) Company *company;

@end

NS_ASSUME_NONNULL_END
