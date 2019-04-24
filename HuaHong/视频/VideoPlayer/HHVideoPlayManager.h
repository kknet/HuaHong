//
//  VideoPlayerManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/11/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHVideoPlayManager : NSObject

+(instancetype)defaultManager;

@property CMTime currentTime;
@property (readonly) CMTime duration;
@property (nonatomic,assign) float rate;
@property (nonatomic,copy) NSURL *URL;

@property (nonatomic,copy) void(^PlaycurrentTime)(float currentTime);
@property (nonatomic,copy) void(^PlayDuration)(BOOL hasValidDuration,float totalTime);
@property (nonatomic,copy) void(^PlayFinished)(void);
@property (nonatomic,copy) void(^PlayRate)(float rate);


/** 将在哪个view上播放 */
- (void)addPlayerLayerTo:(UIView *)view;

//播放
- (void)play;

//停止
- (void)pause;

//快退（2倍）
- (void)rewind;

//快进（2倍）
- (void)fastForward;

//滑动进度条
- (void)changeTimeSlider:(float)value;

/** 移除player */
- (void)removePlayer;
@end

NS_ASSUME_NONNULL_END
