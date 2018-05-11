//
//  User.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface User : NSManagedObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSData * image;
@end
