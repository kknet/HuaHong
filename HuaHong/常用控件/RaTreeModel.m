//
//  RaTreeModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/27.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RaTreeModel.h"

@implementation RaTreeModel

- (id)initWithName:(NSString *)name children:(NSArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
    }
    return self;
}
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children
{
    return [[self alloc] initWithName:name children:children];
}


@end
