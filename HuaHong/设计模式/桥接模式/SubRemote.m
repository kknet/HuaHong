//
//  SubRemote.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "SubRemote.h"

@implementation SubRemote

-(void)up
{
    [super setCommand:@"up"];
}
-(void)down
{
    [super setCommand:@"down"];

}
-(void)left
{
    [super setCommand:@"left"];

}
-(void)right
{
    [super setCommand:@"right"];

}

@end
