//
//  Person.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (copy, nonatomic)NSString *fullName;

-(instancetype)initWithBlock:(NSString *(^)(NSString *firstName,NSString *lastName))block;

-(void)eatWith:(NSString *)objc;

-(void)missMethod:(NSString *)objc;


//nonnull：不能为空,nullable可为空
//对于 双指针类型对象 、 Block 的返回值 、 Block 的参数 等，这时候就不能用 nonnull/nullable 修饰，只能用带下划线的 __nonnull/__nullable 或者 _Nonnull/_Nullable
- (nonnull Person *)run1;

- (Person * _Nonnull (^)(void))run2;

- (Person * _Nonnull (^)(float distance))run3;
@end
