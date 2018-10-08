//
//  DataSource.h
//  HuaHong
//
//  Created by 华宏 on 2018/10/9.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataSource : NSObject

+ (NSArray *)getTableViewArray;
+ (NSArray *)getCollectionViewArray;

@end

NS_ASSUME_NONNULL_END
