//
//  Model.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : BaseModel

@property (nonatomic, copy) NSString *conntentStr;
@property (nonatomic, copy) NSString *imageName;

@property (copy  ,nonatomic) NSString *userID;
@property (copy  ,nonatomic) NSString *name;

- (void)getterMethod;
@end
