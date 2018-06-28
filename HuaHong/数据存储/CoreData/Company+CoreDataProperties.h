//
//  Company+CoreDataProperties.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "Company+CoreDataClass.h"
#import "City+CoreDataClass.h"
#import "Service+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

+ (NSFetchRequest<Company *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *companyId;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) NSSet<Service *> *service;

@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addServiceObject:(Service *)value;
- (void)removeServiceObject:(Service *)value;
- (void)addService:(NSSet<Service *> *)values;
- (void)removeService:(NSSet<Service *> *)values;

@end

NS_ASSUME_NONNULL_END
