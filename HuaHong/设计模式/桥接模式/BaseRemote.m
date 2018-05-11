//
//  Remote.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BaseRemote.h"

@implementation BaseRemote

-(void)setCommand:(NSString *)command
{
    [self.tv loadCommand:command];
}

@end
