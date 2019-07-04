//
//  QKHTTPSessionManager.h
//  HuaHong
//
//  Created by qk-huahong on 2019/7/4.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface QKHTTPSessionManager : AFHTTPSessionManager

@property(nonatomic, copy) NSString *baseUrl;

@end

NS_ASSUME_NONNULL_END
