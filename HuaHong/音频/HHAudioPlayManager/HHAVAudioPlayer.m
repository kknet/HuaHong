//
//  HHAVAudioPlayer.m
//  HuaHong
//
//  Created by 华宏 on 2019/10/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HHAVAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface HHAVAudioPlayer ()
@property (strong,nonatomic) NSTimer *timer;
@end

@implementation HHAVAudioPlayer

+ (HHAVAudioPlayer *)shared
{
    static HHAVAudioPlayer *instance = nil;
       
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           if (!instance)
           {
               instance = [[HHAVAudioPlayer alloc]init];
               [instance setAudioSession];
           }
           
       });
    
       return instance;
}

- (void)setAudioSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    /**
     * AVAudioSessionCategoryPlayAndRecord:允许播放或录制音频，两者不可同时进行
     * AVAudioSessionCategoryAmbient：使用这个category的应用会随着静音键和屏幕关闭而静音。并且不会中止其它应用播放声音，可以和其它自带应用如iPod，safari等同时播放声音。注意：该Category无法在后台播放声音。
     *   AVAudioSessionCategorySoloAmbient：使用这个category的应用会随着静音键和屏幕关闭而静音。不可以与其他声音混合播放，会中断其他声音。
     *   AVAudioSessionCategoryPlayback：使用这个category的应用时，当手机设置为静音或进入后台时会继续播放，如果让使声音在后台继续播放时，必须在plist文件里面添加UIBackgroundModes属性。默认情况下，使用这一类别意味着你的应用程序的音频是不可混合激活的，你的会话将中断任何其他非混合的音频会话。
     *   AVAudioSessionCategoryRecord：用于需要录音的应用，设置该category后，除了来电铃声，闹钟或日历提醒之外的其它系统声音都不会被播放。该Category只提供单纯录音功能。如果让使声音在后台继续播放时，必须在plist文件里面添加UIBackgroundModes属性。
     *   AVAudioSessionCategoryMultiRoute：支持音频播放和录制。允许多条音频流的同步输入和输出。比如：USB 和耳麦同时音频输出。
        
     */
    NSError *error;
  BOOL isSuccess = [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    
    [session setActive:YES error:nil];
    
    if (error) {
        NSLog(@"setAudioSession error:%@",error);
    }
    
    if (isSuccess == NO) {
       NSLog(@"设置AudioSession失败");
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)handleInterruption:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey]unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //播放中断
        [self pause];
        
    }else if (type == AVAudioSessionInterruptionTypeEnded){
       //中断事件结束
        [self startPlay];
    }
}

- (NSTimer *)timer
{
    
    if (!_timer) {
        
        __weak typeof(self) weakSelf = self;

        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
           
            NSTimeInterval currentTime = weakSelf.player.currentTime;
            NSTimeInterval totalTime = weakSelf.player.duration;
            if (weakSelf.progressBlock) {
                weakSelf.progressBlock(currentTime,totalTime);
            }
        }];
    }
    
    return _timer;
}
- (NSTimeInterval)duration
{
    if (self.player) {
        return self.player.duration;
    }
    
    return 0.0;
}

- (BOOL)isPlaying
{
    if (self.player) {
           return self.player.isPlaying;
       }
       
    return NO;
}

- (void)createPlayerWithFilePath:(NSString *)filePath
{
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    
}

- (void)startPlay
{
    if (self.player) {
        
        [_player play];
        [self.timer fire];
    }
    
}

- (void)pause
{
    if (self.player) {
        [_player pause];
        [self timerInvalidate];
    }
   
}

- (void)stop
{
    if (self.player) {
        
     [_player stop];
       _player.currentTime = 0;
       
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
          [self timerInvalidate];
       });
    }
   
    
}

- (BOOL)playAtTime:(NSTimeInterval)time
{
    return [_player playAtTime:time];
}

//MARK: - AVAudioPlayerDelegate

/** 播放完成  */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
}

/* 解码错误 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
   [self timerInvalidate];
}


/* 不推荐使用avaudioplayer中断通知-改用avaudiosession. */

/* 播放中断 */
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
}


/* 中断事件结束 */
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    
    if (flags == AVAudioSessionInterruptionOptionShouldResume) {
        [player play];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0)
{
    
}

/* audioPlayerEndInterruption:withFlags:, 方法未实现 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 6_0)
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerInvalidate
{
    if (self.timer) {
           [self.timer invalidate];
           self.timer = nil;
       }
}
@end
