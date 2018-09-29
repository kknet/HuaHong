//
//  HHAudioTools.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/9.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHAudioTools.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@""]
#define kMp3FileName @"myRecord.mp3"

@interface HHAudioTools()

/***  是否保存  */
@property (nonatomic,assign) BOOL isSave;

/***  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 当前暂停的时间 */
@property (nonatomic,assign) NSTimeInterval pauseTime;

@property (nonatomic, assign) NSTimeInterval timeLength;

//播放录音
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) id timeObserve;
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  设置录音最大时长（默认为60秒）
 */
//@property(assign, nonatomic) NSInteger recordeMaxTime;

/** 最终录音总时间 */
//@property (nonatomic,assign) NSTimeInterval recordeTotalTime;
@end

@implementation HHAudioTools

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

+(HHAudioTools *)sharedTools
{
   static HHAudioTools *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance = [[HHAudioTools alloc]init];
        }

    });
    return instance;
}

/**
 *  开始录音
 *
 *  @param length 录音时长
 */

-(void)startRecorde:(NSTimeInterval)length
{
    _pauseTime = 0;
    _isSave = YES;
    NSError *error = nil;
    
    NSURL *recordeUrl = [NSURL fileURLWithPath:[self getRecordePath]];
    
    NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
    // 音频格式
    recordSetting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    recordSetting[AVSampleRateKey] = @(8000);
    // 音频通道数 1 或 2
    recordSetting[AVNumberOfChannelsKey] = @(2);
    // 线性音频的位深度  8、16、24、32
    recordSetting[AVLinearPCMBitDepthKey] = @(16);
    //录音的质量
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityLow];
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:recordeUrl settings:recordSetting error:&error];
    if (error)
    {
        NSLog(@"error:%@",error);
        return;
    }
    
    //启用分贝检测
    _recorder.meteringEnabled = YES;
    
    _timeLength = length;
    [_recorder recordForDuration:length];
    
    // 如果要在真机运行, 还需要一个session类, 并且制定分类为录音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    _recorder.delegate = self;
    
    [_recorder prepareToRecord];
    [_recorder record];

    
    //进行分贝的循环检测 --> 添加计时器(如果分贝值长时间小于某个值，则自动停止录音)
    [self updateMetering];
    
}


#pragma mark 添加计时器
- (void)updateMetering
{
    // 如果没有displayLink就创建
    if (self.displayLink == nil) {
        //1. 创建displayLink
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
        
        //2. 添加到运行循环中
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    // 判断如果暂停了循环, 就打开
    if (self.displayLink.isPaused) {
        self.displayLink.paused = NO;
    }
}

#pragma mark 循环调用的方法
- (void)updateMeter
{
    //需求: 自动停止录音 --> 根据分贝的大小来判断
    
    //1. 我们需要获取分贝信息
    //2. 设置分贝如果小于某个值, 一定时间后, 自动停止
    
    //1. 更新分贝信息
    [self.recorder updateMeters];
    
    //2. 获取分贝信息 --> iOS直接传0
    // 0 ~ -160 , 值最大是0, 最小是-160. 系统返回的是负值
    CGFloat power = [self.recorder averagePowerForChannel:0];
    
    //3. 实现2S自动停止
    static NSInteger number;
    
    //displayLink,一秒默认是60次, 如果120此的调用都小于某个分贝值, 我们就可以认为要自动停止
    
    //3.1 先判断用户是否小于某个分贝值 --> 用户是否没说话
    if (power < -30) {
        
        //3.2 如果发现很安静, 我们就可以记录一下, number进行叠加
        number++;
        
        //3.3 如果发现120次了, 都小于设定的分贝值
        if (number / 60 >= 2) {
            
            //3.4 调用停止方法
            [self stopRecorde:YES];
        }
    } else {
        number = 0;
    }
    
    NSLog(@"power: %f",power);
}

-(void)pauseRecorde
{
    [_recorder pause];
    _pauseTime = _recorder.currentTime;
    
    // 暂停循环
    self.displayLink.paused = YES;
}

-(void)continueRecorde
{
    [_recorder recordForDuration:_timeLength];
    [_recorder recordAtTime:_pauseTime];
}

-(void)stopRecorde:(BOOL)isSave
{
    if (_recorder.isRecording == NO) {
        return;
    }
    
    _isSave = isSave;
    
    if (_recorder) {
        [_recorder stop];
    }
    
    // 暂停循环
    self.displayLink.paused = YES;
}

-(NSString *)getRecordePath
{
    return [RecordFile stringByAppendingPathComponent:_recordeFileName];
}

-(void)deleteRecord
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self getRecordePath]]) {
        [fileManager removeItemAtPath:[self getRecordePath] error:nil];
    }
}

-(void)resetRecorder
{
    _pauseTime = 0;
    //    _recordeTotalTime = 0;
    
    [self deleteRecord];
}

/**
   AVAudioPlayer
 */
-(void)playRecord:(NSString *)urlStr
{
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    _audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    
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
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    return sizeText;
}

#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (_isSave)
    {
        if (_recordeBlock) {
            _recordeBlock([self getRecordePath]);
        }
    }else
    {
        [self deleteRecord];
    }
}

@end
