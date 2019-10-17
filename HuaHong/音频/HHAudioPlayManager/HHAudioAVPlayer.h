//
//  HHAudioAVPlayer.h
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordeBlock)(NSString *recordePath);
@interface HHAudioAVPlayer : NSObject

+ (instancetype)shared;

- (instancetype)initWithURLString:(NSString *)url;

- (void)startPlayWithProgressCallback:(void (^)(CGFloat, NSString *, NSString *))progressCallback;

- (void)pause;

- (void)stop;

@property (nonatomic,copy) void(^playAuidoFinishedCallback)(void);

/** 获取录音时长 */
- (float)getVoiceDuration;

@end
