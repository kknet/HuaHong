//
//  HHAudioAVPlayer.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "HHAudioAVPlayer.h"

@interface HHAudioAVPlayer()

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) id timeObserve;
@property (nonatomic,   copy) NSString *url;

@end

@implementation HHAudioAVPlayer

//MARK: - 单例
+(HHAudioAVPlayer *)shared
{
    static HHAudioAVPlayer *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance = [[HHAudioAVPlayer alloc]init];
        }
        
    });
    return instance;
}

- (instancetype)initWithURLString:(NSString *)url
{
    self = [super init];
    if (self) {
        _url = url;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    
    return self;
}

- (AVPlayer *)player
{
    if (!_player) {
        
        
        if ([_url hasPrefix:@"http"])
        {
            _playerItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:_url]];
            _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        }else
        {
            NSURL *url = [NSURL fileURLWithPath:_url];
            AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
            _playerItem = [[AVPlayerItem alloc]initWithAsset:asset];
            _player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    }
    
    return _player;
}

- (void)startPlayWithProgressCallback:(void (^)(CGFloat, NSString *, NSString *))progressCallback
{
    if (_url == nil || _url.length == 0) {
        return;
    }
    
    [self stop];
    
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weakSelf.playerItem.duration);
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
    
    
}


- (void)pause
{
    if (self.player)
    {
        [self.player pause];
        
        if (self.timeObserve)
        {
            [self.player removeTimeObserver:self.timeObserve];
            self.timeObserve = nil;
        }
        
        //        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
//        self.player = nil;
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)playAudioFinished:(NSNotification *)noti
{
    if (_playAuidoFinishedCallback) {
        _playAuidoFinishedCallback();
    }
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSURL *audioFileURL = [NSURL fileURLWithPath:_url];
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

