//
//  VideoPlayerManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerManager : NSObject

+(instancetype)defaultManager;

@property (nonatomic,copy) NSURL *URL;
@property (nonatomic,copy) void(^PlayFinished)();

/** 将在哪个view上播放 */
- (void)addPlayerLayerTo:(UIView *)view;

- (void)play;
- (void)pause;

/** 移除player */
- (void)removePlayer;
@end

NS_ASSUME_NONNULL_END
