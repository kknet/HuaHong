//
//  NSObject+swizzle.h
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (bury)

@property (nonatomic,copy) IBInspectable NSString *key;

+ (void)swizzleInstanceMethod:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL;

+ (void)swizzleClassMethod:(SEL)originalSEL swizzledSEL:(SEL)swizzledSEL;

@end

NS_ASSUME_NONNULL_END
