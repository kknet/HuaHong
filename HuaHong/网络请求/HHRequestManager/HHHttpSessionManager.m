//
//  HHHttpSessionManager.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/1.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HHHttpSessionManager.h"

@implementation HHHttpSessionManager

- (NSURL *)baseURL
{
    return [NSURL URLWithString:self.baseUrl];
}

@end
