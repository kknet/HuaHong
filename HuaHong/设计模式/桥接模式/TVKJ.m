//
//  TVKJ.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TVKJ.h"

@implementation TVKJ

-(void)loadCommand:(NSString *)command
{
    if ([command isEqualToString:@"up"]) {
       
        NSLog(@"KJTV : %@",command);
        
    }else if ([command isEqualToString:@"down"])
    {
        NSLog(@"KJTV : %@",command);

    }else if ([command isEqualToString:@"left"])
    {
        NSLog(@"KJTV : %@",command);

    }else if ([command isEqualToString:@"right"])
    {
        NSLog(@"KJTV : %@",command);

    }
}
@end
