//
//  QKHTTPSessionManager.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/4.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "QKHTTPSessionManager.h"

@implementation QKHTTPSessionManager

- (NSURL *)baseURL
{
    return [NSURL URLWithString:self.baseUrl];
}

@end
