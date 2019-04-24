//
//  HHAudioRecorder.m
//  HuaHong
//
//  Created by 华宏 on 2019/4/23.
//  Copyright © 2019年 huahong. All rights reserved.
//

#import "HHAudioRecorder.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@""]
#define kMp3FileName @"myRecord.mp3"

@interface HHAudioRecorder()

/***  是否保存  */
@property (nonatomic,assign) BOOL isSave;

/***  录音对象  */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 当前暂停的时间 */
@property (nonatomic,assign) NSTimeInterval pauseTime;

@end

@implementation HHAudioRecorder


+(HHAudioRecorder *)sharedManager
{
    static HHAudioRecorder *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance)
        {
            instance = [[HHAudioRecorder alloc]init];
        }
        
    });
    return instance;
}

- (NSString *)fileName
{
    //不设置，默认为当时时间
    if (_fileName== nil || _fileName.length == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:dd";
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
        _fileName = [formatter stringFromDate:NSDate.date];
    }
    
    return _fileName;
}
    
- (NSTimeInterval)recordLength
{
    //不设置，默认为CGFLOAT_MAX
    if (!_recordLength) {
        _recordLength = CGFLOAT_MAX;
    }
    
    return _recordLength;
}
/**
 *  开始录音
 */
-(void)startRecorde
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
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityMax];
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:recordeUrl settings:recordSetting error:&error];
    if (error)
    {
        NSLog(@"error:%@",error);
        return;
    }
    
    //启用分贝检测
    _recorder.meteringEnabled = YES;
    
    [_recorder recordForDuration:self.recordLength];
    
    // 如果要在真机运行, 还需要一个session类, 并且制定分类为录音
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    _recorder.delegate = self;
    
    [_recorder prepareToRecord];
    [_recorder record];
    
    
    //进行分贝的循环检测 --> 添加计时器(如果分贝值长时间小于某个值，则自动停止录音)
//    [self updateMetering];
   
    NSLog(@"开始录音");
}


//#pragma mark 添加计时器
//- (void)updateMetering
//{
//    // 如果没有displayLink就创建
//    if (self.displayLink == nil) {
//        //1. 创建displayLink
//        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
//
//        //2. 添加到运行循环中
//        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    }
//
//    // 判断如果暂停了循环, 就打开
//    if (self.displayLink.isPaused) {
//        self.displayLink.paused = NO;
//    }
//}
//
//#pragma mark 循环调用的方法
//- (void)updateMeter
//{
//    //需求: 自动停止录音 --> 根据分贝的大小来判断
//
//    //1. 我们需要获取分贝信息
//    //2. 设置分贝如果小于某个值, 一定时间后, 自动停止
//
//    //1. 更新分贝信息
//    [self.recorder updateMeters];
//
//    //2. 获取分贝信息 --> iOS直接传0
//    // 0 ~ -160 , 值最大是0, 最小是-160. 系统返回的是负值
//    CGFloat power = [self.recorder averagePowerForChannel:0];
//
//    //3. 实现2S自动停止
//    static NSInteger number;
//
//    //displayLink,一秒默认是60次, 如果120此的调用都小于某个分贝值, 我们就可以认为要自动停止
//
//    //3.1 先判断用户是否小于某个分贝值 --> 用户是否没说话
//    if (power < -30) {
//
//        //3.2 如果发现很安静, 我们就可以记录一下, number进行叠加
//        number++;
//
//        //3.3 如果发现120次了, 都小于设定的分贝值
//        if (number / 60 >= 2) {
//
//            //3.4 调用停止方法
//            [self stopRecorde:YES];
//        }
//    } else {
//        number = 0;
//    }
//
//    NSLog(@"power: %f",power);
//}

-(void)pauseRecorde
{
    [_recorder pause];
    _pauseTime = _recorder.currentTime;
    
    // 暂停循环
//    self.displayLink.paused = YES;
    NSLog(@"暂停录音");
}

-(void)continueRecorde
{
    [_recorder recordForDuration:_recordLength];
    [_recorder recordAtTime:_pauseTime];
    
    NSLog(@"继续录音");
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
//    self.displayLink.paused = YES;
    
    NSLog(@"结束录音");
}

-(NSString *)getRecordePath
{
    return [[RecordFile stringByAppendingPathComponent:self.fileName]stringByAppendingString:@".caf"];
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
