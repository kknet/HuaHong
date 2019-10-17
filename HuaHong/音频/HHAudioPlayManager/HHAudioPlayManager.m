//
//  HHAudioPlayManager.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "HHAudioPlayManager.h"

@interface HHAudioPlayManager()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) id timeObserve;

@end

@implementation HHAudioPlayManager

//MARK: - 单例
+(HHAudioPlayManager *)sharedManager
{
    static HHAudioPlayManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance = [[HHAudioPlayManager alloc]init];
        }
        
    });
    return instance;
}


//MARK: - AVPlayer
-(void)playAudioWhithURL:(NSString *)urlStr progresscallback:(void (^)(CGFloat, NSString *, NSString *))progressCallback
{
    [self stop];
    AVPlayerItem *songItem;
    
    if ([urlStr hasPrefix:@"http"])
    {
        songItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
    }else
    {
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        songItem = [[AVPlayerItem alloc]initWithAsset:asset];
    }
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
        if (current)
        {
            float progress = current / total;
            NSString *currentStr = [NSString stringWithFormat:@"%.f",current];
            NSString *totalStr = [NSString stringWithFormat:@"%.f",total];
            
            if (progressCallback)
            {
                progressCallback(progress,currentStr,totalStr);
            }
            
        }
    }];
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playAudioFinished:(NSNotification *)noti
{
    if (_playAuidoFinishedCallback) {
        _playAuidoFinishedCallback();
    }
}

- (void)stop
{
    if (self.player)
    {
        [self.player pause];
        
        if (self.timeObserve)
        {
            [self.player removeTimeObserver:self.timeObserve];
            self.timeObserve = nil;
        }
        
        self.player = nil;

        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//MARK: - 获取录音文件大小
-(NSString *)size:(unsigned long long)size
{
    NSString *sizeText = @"";
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%lluB", size];
    }
    return sizeText;
}


//MARK: - 获取录音时长
- (float)getVoiceDuration
{
    NSURL *audioFileURL = [NSURL fileURLWithPath:@""];
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}

//MARK: - 距离传感器
-(void)distanceSence
{
    //开启接近监视(靠近耳朵的时候听筒播放,离开的时候扬声器播放)
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
}

-(void)sensorStateChange:(NSNotification *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //靠近耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        //离开耳朵
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


@end

