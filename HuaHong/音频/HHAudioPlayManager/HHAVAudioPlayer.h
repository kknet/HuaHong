//
//  HHAVAudioPlayer.h
//  HuaHong
//
//  Created by 华宏 on 2019/10/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AVAudioPlayerProgressBlock)(NSTimeInterval currentTime,NSTimeInterval totalTime);
@interface HHAVAudioPlayer : NSObject<AVAudioPlayerDelegate>

+ (HHAVAudioPlayer *)shared;

@property (nonatomic, strong,readonly) AVAudioPlayer *player;
@property (nonatomic, copy) AVAudioPlayerProgressBlock progressBlock;
@property(readonly) NSTimeInterval duration;

@property(readonly, getter=isPlaying) BOOL playing;

- (void)createPlayerWithFilePath:(NSString *)filePath;

- (void)startPlay;

- (void)pause;

- (void)stop;

- (BOOL)playAtTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
