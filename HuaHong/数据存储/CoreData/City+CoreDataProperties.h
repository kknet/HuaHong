//
//  City+CoreDataProperties.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/27.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *cityId;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nullable, nonatomic, retain) NSSet<Company *> *company;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addCompanyObject:(Company *)value;
- (void)removeCompanyObject:(Company *)value;
- (void)addCompany:(NSSet<Company *> *)values;
- (void)removeCompany:(NSSet<Company *> *)values;

@end

NS_ASSUME_NONNULL_END
