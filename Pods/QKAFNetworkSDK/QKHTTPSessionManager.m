//
//  QKHTTPSessionManager.m
//  QKPublic
//
//  Created by chenhanlin on 2017/9/7.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import "QKHTTPSessionManager.h"

@implementation QKHTTPSessionManager

- (NSURL *)baseURL {
    return [NSURL URLWithString:self.baseUrl];
}

@end
