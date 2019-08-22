//
//  VideoRecordController.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/30.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "VideoRecordController.h"

@interface VideoRecordController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureDeviceInput *frontInput;
@property (nonatomic,strong) AVCaptureDeviceInput *backInput;
@property (nonatomic,strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic,strong) AVCaptureConnection *videoConnection;
@property (nonatomic,strong) AVCaptureConnection *audioConnection;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) AVAssetWriter *writer;
@end

@implementation VideoRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)begainrecord
{
    self.previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.session startRunning];
}

- (void)back
{
   [self.session stopRunning];
}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//同一个代理方法
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    @autoreleasepool {
        
        if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo])
        {
            
        }
    }
}


- (AVCaptureDeviceInput *)frontInput
{
    if (_frontInput == nil)
    {
        AVCaptureDevice *frontDevice ;
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionFront) {
                frontDevice = device;
            }
        }
        
        _frontInput = [AVCaptureDeviceInput deviceInputWithDevice:frontDevice error:nil];
    }
    
    return _frontInput;
}

- (AVCaptureDeviceInput *)backInput
{
    if (_backInput == nil)
    {
        AVCaptureDevice *backDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _backInput = [AVCaptureDeviceInput deviceInputWithDevice:backDevice error:nil];
    }
    
    return _backInput;
}

- (AVCaptureDeviceInput *)audioInput
{
    if (_audioInput == nil)
    {
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
    }
    
    return _audioInput;
}

- (AVCaptureVideoDataOutput *)videoOutput
{
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc]init];
        [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        NSDictionary *setting = @{(__bridge id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
//        NSDictionary* setting = [NSDictionary dictionaryWithObjectsAndKeys:
//
//                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
//                                        nil];
        _videoOutput.videoSettings = setting;

    }
    
    return _videoOutput;
}

- (AVCaptureAudioDataOutput *)audioOutput
{
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc]init];
        [_audioOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    
    return _audioOutput;
}
- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
      
        /** 默认后摄像头,所以前摄像头不需要添加 */
//        if ([_session canAddInput:self.frontInput]) {
//            [_session addInput:_frontInput];
//        }
        
        if ([_session canAddInput:self.backInput]) {
            [_session addInput:_backInput];
        }
        
        if ([_session canAddOutput:self.videoOutput]) {
            [_session addOutput:_videoOutput];
        }
        
        if ([_session canAddInput:self.audioInput]) {
            [_session addInput:_audioInput];
        }
        
        if ([_session canAddOutput:self.audioOutput]) {
            [_session addOutput:_audioOutput];
        }
        
        self.videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
        //设置分辨率
        if ([_session canSetSessionPreset: AVCaptureSessionPresetHigh]) {
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
        }
        
    }
    
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewLayer;
}

- (AVCaptureConnection *)videoConnection
{
    if (!_videoConnection) {
        _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    }
    return _videoConnection;
}

- (AVCaptureConnection *)audioConnection
{
    if (!_audioConnection) {
        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
    }
    return _audioConnection;
}

- (AVAssetWriter *)writer
{
    
    _writer = [[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:[self getPath]] fileType:AVFileTypeMPEG4 error:nil];
    
    //写入视频的大小
    NSInteger numPixels = 720 * 1280;
    
    //每像素比特
    CGFloat bitsPerPixel = 6.0;
    NSInteger bitsPerSecond = numPixels * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *properties = @{AVVideoAverageBitRateKey:@(bitsPerSecond),
        AVVideoExpectedSourceFrameRateKey : @(30),
        AVVideoMaxKeyFrameIntervalKey : @(30),
        AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel};
                                     
    //视频属性
    NSDictionary *videoSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
       AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
       AVVideoWidthKey : @(720),
       AVVideoHeightKey : @(1280),
       AVVideoCompressionPropertiesKey :properties
                                
        };

    AVAssetWriterInput *assetVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    assetVideoInput.expectsMediaDataInRealTime = YES;
    assetVideoInput.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    // 音频设置
   NSDictionary *audioSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                       AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                       AVNumberOfChannelsKey : @(1),
                                       AVSampleRateKey : @(22050) };
    

    AVAssetWriterInput *assetAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioSettings];
    assetAudioInput.expectsMediaDataInRealTime = YES;
    
    if ([_writer canAddInput:assetVideoInput]) {
        [_writer addInput:assetVideoInput];
    }
    
    if ([_writer canAddInput:assetAudioInput]) {
        [_writer addInput:assetAudioInput];
    }
    
    
    return _writer;
}

- (NSString *)getPath
{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date = [format stringFromDate:[NSDate date]];
    NSString *exten = [date stringByAppendingPathExtension:@"mp4"];
    return [doc stringByAppendingPathComponent:exten];
}

@end
