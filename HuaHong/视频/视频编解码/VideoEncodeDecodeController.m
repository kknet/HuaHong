//
//  VideoEncodeDecodeController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/30.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "VideoEncodeDecodeController.h"
#import "SystemCapture.h"
#import "AAPLEAGLLayer.h"
#import "H264EncodeTool.h"
#import "H264DecodeTool.h"

@interface VideoEncodeDecodeController ()<SystemCaptureDelegate,H264EncodeDelegate,H264DecodeDelegate>

@property (nonatomic, strong) SystemCapture *capture;
@property (nonatomic,strong)AAPLEAGLLayer *playLayer;  //解码后播放layer

//编解码器
@property (nonatomic,strong)H264DecodeTool *h264Decoder;
@property (nonatomic,strong)H264EncodeTool *h264Encoder;

@end

@implementation VideoEncodeDecodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频编解码";
    
    [SystemCapture checkCameraAuthor];
    _capture = [[SystemCapture alloc] initWithType:SystemCaptureTypeVideo];
    CGFloat height = (self.view.frame.size.height - 64)/2.0;
    CGFloat width = self.view.frame.size.width;
    CGSize size = CGSizeMake(width, height);
    [_capture prepareWithPreviewSize:size];  //捕获视频时传入预览层大小
    _capture.preview.frame = CGRectMake(0, 64, size.width, size.height);
    [self.view addSubview:_capture.preview];
    self.capture.delegate = self;
    
    
    [self startCaputureSession];
}

#pragma mark - EventHandle
- (void)startBtnAction
{
    BOOL isRunning = self.capture.isRecording;
    
    if (isRunning) {
        //        //停止采集编码
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
        //        });
        
        [self endCaputureSession];
    }else{
        //        //开始采集编码
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //             [self.startBtn setTitle:@"End" forState:UIControlStateNormal];
        //        });
        
        [self startCaputureSession];
    }
}

- (void)startCaputureSession{
    
    //开始采集
    [self.capture startRunning];
    
    //设置YUV420p输出
    //    [self.captureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
}

- (void)endCaputureSession
{
    //停止采集
    [self.capture stopRunning];
    
    //停止编码
    [self.h264Encoder stopEncode];
    
    //停止解码
    [self.h264Decoder endDecode];
    
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if ([output isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        [self.h264Encoder encode:sampleBuffer];
    }
}

#pragma mark - 编码回调
- (void)gotSpsPps:(NSData *)sps pps:(NSData *)pps{
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    //sps
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:sps];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
    
    
    //pps
    [h264Data resetBytesInRange:NSMakeRange(0, [h264Data length])];
    [h264Data setLength:0];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:pps];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
}

- (void)gotEncodedData:(NSData *)data isKeyFrame:(BOOL)isKeyFrame{
    const char bytes[] = "\x00\x00\x00\x01";
    size_t length = (sizeof bytes) - 1;
    NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
    NSMutableData *h264Data = [[NSMutableData alloc] init];
    [h264Data appendData:ByteHeader];
    [h264Data appendData:data];
    [self.h264Decoder decodeNalu:(uint8_t *)[h264Data bytes] size:(uint32_t)h264Data.length];
}


#pragma mark - 解码回调
- (void)gotDecodedFrame:(CVImageBufferRef)imageBuffer{
    if(imageBuffer)
    {
        //解码回来的数据绘制播放
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.playLayer.pixelBuffer = imageBuffer;
        });
        
        CVPixelBufferRelease(imageBuffer);
    }
}

#pragma mark - Getters

- (AAPLEAGLLayer *)playLayer
{
    if (!_playLayer) {
        CGFloat height = (self.view.frame.size.height - 64)/2.0;
        CGFloat width = self.view.frame.size.width;
        _playLayer = [[AAPLEAGLLayer alloc] initWithFrame:CGRectMake(0,64+height,width,height)];
        _playLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.view.layer addSublayer:_playLayer];
    }
    
    return _playLayer;
}
- (H264EncodeTool *)h264Encoder
{
    if (!_h264Encoder) {
        _h264Encoder = [[H264EncodeTool alloc]init];
        [_h264Encoder initEncode:640 height:480];
        _h264Encoder.delegate = self;
    }
    
    return _h264Encoder;
}

- (H264DecodeTool *)h264Decoder
{
    if (!_h264Decoder) {
        _h264Decoder = [[H264DecodeTool alloc] init];
        _h264Decoder.delegate = self;
    }
    
    return _h264Decoder;
}

@end
