//
//  RaTreeModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RaTreeModel : NSObject

@property (nonatomic,copy) NSString *name;//标题

@property (nonatomic,strong) NSArray *children;//子节点数组

//初始化一个model
- (id)initWithName:(NSString *)name children:(NSArray *)array;

//遍历构造器
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end

