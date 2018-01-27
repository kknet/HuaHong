//
//  DataModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject<NSCoding>

@property (nonatomic,copy)   NSString *name;
@property (nonatomic,assign) NSInteger age;

@end
