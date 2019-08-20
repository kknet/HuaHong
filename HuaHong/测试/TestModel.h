//
//  TestModel.h
//  HuaHong
//
//  Created by 华宏 on 2019/5/10.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SecondModel;
NS_ASSUME_NONNULL_BEGIN

@interface TestModel : BaseModel
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) SecondModel *second;
@end

@interface SecondModel : BaseModel
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,copy) NSString *name;
@end

NS_ASSUME_NONNULL_END
