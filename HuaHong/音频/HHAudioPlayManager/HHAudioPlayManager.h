//
//  HHAudioPlayManager.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordeBlock)(NSString *recordePath);
@interface HHAudioPlayManager : NSObject

+ (instancetype)sharedManager;

/**
 *  AVPlayer 播放录音
 */

- (instancetype)initWithURLString:(NSString *)url;

- (void)startPlayWithProgressCallback:(void (^)(CGFloat, NSString *, NSString *))progressCallback;

- (void)pausePlay;

- (void)stopPlay;

@property (nonatomic,copy) void(^playAuidoFinishedCallback)(void);

/** 获取录音时长 */
- (float)getVoiceDuration;

@end
