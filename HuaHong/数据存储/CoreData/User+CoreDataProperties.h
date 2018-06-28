//
//  User+CoreDataProperties.h
//  HuaHong
//
//  Created by 华宏 on 2018/6/28.
//  Copyright © 2018年 huahong. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int64_t age;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, retain) Company *company;

@end

NS_ASSUME_NONNULL_END
