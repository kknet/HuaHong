//
//  Factory.h
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flower.h"
NS_ASSUME_NONNULL_BEGIN

@interface Factory : NSObject

@property (nonatomic,strong) NSMutableDictionary *flowerPools;
- (Flower *)flowerWithType:(FlowerType)type;

@end

NS_ASSUME_NONNULL_END
