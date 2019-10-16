//
//  HHAudioPlayManager.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "HHAudioPlayManager.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@""]
#define kMp3FileName @"myRecord.mp3"

@interface HHAudioPlayManager()

@property (nonatomic, strong) CADisplayLink *displayLink;

//播放录音
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) id timeObserve;

@end

@implementation HHAudioPlayManager

static NSMutableDictionary *_soundIDDict;
+ (void)initialize
{
    _soundIDDict = [NSMutableDictionary dictionary];
}

#pragma mark - 播放音效
+ (void)playSystemSoundWithURL:(NSURL *)url
{
    // 不带震动的播放
    AudioServicesPlaySystemSound([self loadSoundIDWithURL:url]);
}

/** 播放震动音效*/
+ (void)playAlertSoundWithURL:(NSURL *)url
{
    // 带震动的播放
    AudioServicesPlayAlertSound([self loadSoundIDWithURL:url]);
    
}

// 播放音效的公用方法
+ (SystemSoundID)loadSoundIDWithURL:(NSURL *)url
{
    // 思路思路
    // soundID重复创建 --> soundID每次创建, 就会有对应的URL地址产生
    // 可以将创建后的soundID 及 对应的URL 进行缓存处理
    
    //1. 获取URL的字符串
    NSString *urlStr = url.absoluteString;
    
    //2. 从缓存字典中根据URL来取soundID 系统音效文件
    SystemSoundID soundID = [_soundIDDict[urlStr] intValue];
    
    //需要在刚进入的时候, 判断缓存字典是否有url对应的soundID
    
    //3. 判断soundID是否为0, 如果为0, 说明没有找到, 需要创建
    if (soundID == 0) {
        //3.1 创建音效文件
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        
        //3.2 缓存字典的添加键值
        _soundIDDict[urlStr] = @(soundID);
    }
    
    return soundID;
}


/** 清空音效文件的内存*/
+ (void)clearMemory
{
    //1. 遍历字典
    [_soundIDDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //2. 清空音效文件的内存
        SystemSoundID soundID = [obj intValue];
        AudioServicesDisposeSystemSoundID(soundID);
    }];
}

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


/**
 AVAudioPlayer
 */
-(void)playRecord:(NSString *)urlStr
{
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _audioPlayer.delegate = self;
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"AVAudioPlayer播放完成");
}

//距离传感器
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

-(void)AVAudioStop
{
    //暂停
    //    [_audioPlayer pause];
    
    //停止
    [_audioPlayer stop];
    _audioPlayer.currentTime = 0;
}

/**
 AVPlayer
 */
-(void)playAudioWhithURL:(NSString *)urlStr progresscallback:(void (^)(CGFloat, NSString *, NSString *))progressCallback
{
    [self stopPlayAudio];
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

-(void)stopPlayAudio
{
    if (self.player)
    {
        [self.player pause];
        self.player = nil;
        
        if (self.timeObserve)
        {
            [self.player removeTimeObserver:self.timeObserve];
            self.timeObserve = nil;
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


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



/** 获取录音时长 */
- (float)getVoiceDuration
{
    NSURL *audioFileURL = [NSURL fileURLWithPath:@""];
    AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    
    return audioDurationSeconds;
}
@end

