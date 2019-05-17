//
//  NSDictionary+CrashHandle.h
//  RequestDemo
//
//  Created by huafeng on 2019/3/15.
//  Copyright © 2019年 雷雷. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

@end

@interface NSDictionary (NilSafe)

@end

@interface NSMutableDictionary (NilSafe)

@end

@interface NSArray (NilSafe)

@end

@interface NSMutableArray (NilSafe)

@end

@interface NSArray (SingleNilSafe)

@end

@interface NSArray (PlaceholderNilSafe)

@end

NS_ASSUME_NONNULL_END
