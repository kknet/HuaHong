//
//  BaseAdapter.h
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "BaseAdapterProtocol.h"
@interface BaseAdapter : NSObject<BaseAdapterProtocol>

/**
 *  输入对象
 */
@property (nonatomic, weak) id data;

/**
 *  与输入对象建立联系
 *
 *  @param data 输入的对象
 *
 *  @return 实例对象
 */
- (instancetype)initWithData:(id)data;

@end
