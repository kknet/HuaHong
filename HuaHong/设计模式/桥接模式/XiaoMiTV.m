//
//  XiaoMiTV.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "XiaoMiTV.h"

@implementation XiaoMiTV

-(void)loadCommand:(NSString *)command
{
    if ([command isEqualToString:@"up"]) {
        
        NSLog(@"XiaoMiTV : %@",command);
        
    }else if ([command isEqualToString:@"down"])
    {
        NSLog(@"XiaoMiTV : %@",command);
        
    }else if ([command isEqualToString:@"left"])
    {
        NSLog(@"XiaoMiTV : %@",command);
        
    }else if ([command isEqualToString:@"right"])
    {
        NSLog(@"XiaoMiTV : %@",command);
        
    }
}
@end
