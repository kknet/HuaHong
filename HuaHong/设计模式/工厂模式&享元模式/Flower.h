//
//  Flower.h
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,FlowerType){
    kRedColor,
    kBlueColor,
    kYellowColor,
    kTotalColors
};
@interface Flower : NSObject

@property (nonatomic,copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
