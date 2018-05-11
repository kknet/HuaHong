//
//  Remote.h
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTV.h"

@interface BaseRemote : NSObject

@property (nonatomic,strong) BaseTV *tv;


-(void)setCommand:(NSString *)command;

@end
