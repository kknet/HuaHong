//
//  AudioRecorderManager.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/6.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "AudioRecorderManager.h"

#define RecordFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@""]
#define kMp3FileName @"myRecord.mp3"

@implementation AudioRecorderManager
{
//    NSString *recordePath;
    AVAudioPlayer *audioPlayer;
    NSTimeInterval _timeLength;
}

+(AudioRecorderManager *)sharedRecorde
{
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setActive:YES error:nil];
    if (error) {
        NSLog(@"获取权限失败");
        return nil;
    }
    
    AudioRecorderManager *recorder = [[AudioRecorderManager alloc]init];
    return recorder;
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
    //    recordSetting[AVLinearPCMBitDepthKey] = @(16);
    //录音的质量
    recordSetting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityLow];
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:recordeUrl settings:recordSetting error:&error];
    if (_recorder == nil)
    {
        NSLog(@"生成录音对象失败error:%@",error);
        return;
    }
    
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    
    //启用录音测量
    _recorder.meteringEnabled = YES;
    
    _timeLength = length;
    [_recorder recordForDuration:length];
    [_recorder record];
    
}

-(void)pauseRecorde
{
    [_recorder pause];
    _pauseTime = _recorder.currentTime;
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

-(void)playRecord:(NSString *)recordPath
{
    //开启接近监视(靠近耳朵的时候听筒播放,离开的时候扬声器播放)
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];

    NSURL *url = [NSURL fileURLWithPath:recordPath];
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
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

//- (NSString *)transformCAFToMP3:(NSURL *)sourceUrl
//{
//
//
//    NSFileManager *manager = [NSFileManager defaultManager];
//    unsigned long long size = [manager attributesOfItemAtPath:[sourceUrl absoluteString] error:nil].fileSize;
//
//
//    NSURL *mp3FilePath,*audioFileSavePath;
//
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    mp3FilePath = [NSURL URLWithString:[path stringByAppendingPathComponent:kMp3FileName]];
//
//    @try {
//        int read, write;
//
//        FILE *pcm = fopen([[sourceUrl absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
//        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
//        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
//
//        NSLog(@"sour-- %@   last-- %@",sourceUrl,mp3FilePath);
//
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 8000);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//
//        do {
//            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//            if (read == 0)
//                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//            else
//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//
//            fwrite(mp3_buffer, write, 1, mp3);
//
//        } while (read != 0);
//
//        lame_close(lame);
//        fclose(mp3);
//        fclose(pcm);
//    }
//    @catch (NSException *exception) {
//        //TODO:待处理
//        NSLog(@"%@",[exception description]);
//        NSLog(@"MP3转换失败");
//    }
//    @finally {
//        audioFileSavePath = mp3FilePath;
//        NSLog(@"MP3生成成功: %@",audioFileSavePath);
//        NSString *str = audioFileSavePath.path;
//        NSLog(@"str == %@",str);
//
//
//        unsigned long long size1 = [manager attributesOfItemAtPath:str error:nil].fileSize;
//
//        NSLog(@"转换前 == %@, 转换后 == %@",[self size:size], [self size:size1]);
//
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"mp3转化成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        //        [alert show];
//        //        url_str = str;
//        //        [self playRecord];
//    }
//
//    return audioFileSavePath.path;
//}

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
