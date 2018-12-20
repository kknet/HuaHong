//
//  QKHTTPSessionManager.h
//  QKPublic
//
//  Created by chenhanlin on 2017/9/7.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QKHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic, strong) NSString *baseUrl;

@end
