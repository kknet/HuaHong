//
//  HHProxy.h
//  HuaHong
//
//  Created by 华宏 on 2018/12/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHProxy : NSProxy
@property (nonatomic,weak) id target;
@end

NS_ASSUME_NONNULL_END
