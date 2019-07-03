//
//  NSDictionary+Null.h
//  HuaHong
//
//  Created by qk-huahong on 2019/6/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Null)

- (NSDictionary *)filterNull;

@end

@interface NSArray (Null)

- (NSArray *)filterNull;

@end

NS_ASSUME_NONNULL_END
