//
//  LightSinceController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "LightSinceController.h"

@interface LightSinceController ()
@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureVideoDataOutput *output;
@end

@implementation LightSinceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.title = @"利用摄像头捕捉光感参数";
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    label.numberOfLines =  0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    label.text = @"环境变暗后就自动提示是否打开闪光灯，打开之后，环境变亮后会自动提示是否关闭闪光灯。";
    
    [self lightSensitive];
}


//利用摄像头获取环境光感参数 比如拍照时光线暗的时候闪光灯自动打开
- (void)lightSensitive
{
    // .获取硬件设备
    if (self.device == nil) {
        NSLog(@"设备不支持");
        return;
    }
    
    // .创建设备输出流
    [self.output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置为高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 添加会话输入和输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    //启动会话
    [self.session startRunning];
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    NSLog(@"环境光感 ： %f",brightnessValue);
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    // 判断设备是否有手电筒
    BOOL result = [self.device hasTorch];
    
    if (brightnessValue < 0 && result)
    {
        // 打开闪光灯
        if (self.device.torchMode == AVCaptureTorchModeOn)
        {
            return;
        }
        
        [self showAlert:@"是否打开闪光灯？"];
        
    }else if (brightnessValue > 0 && result)
    {
        // 关闭闪光灯
        if (self.device.torchMode == AVCaptureTorchModeOff)
        {
            return;
        }
        
        [self showAlert:@"是否关闭闪光灯？"];
        
        
    }
    
}

-(void)showAlert:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([message containsString:@"打开"]) {
            // 打开闪光灯
            
            [self turnOnFlash];
            
        }else if ([message containsString:@"关闭"])
        {
            // 关闭闪光灯
            [self turnOffFlash];
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 打开闪光灯
-(void)turnOnFlash
{
    //    if (self.device.torchMode == AVCaptureTorchModeOff) {
    //
    //    }
    
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
    
}

// 关闭闪光灯
-(void)turnOffFlash
{
    //    if (self.device.torchMode == AVCaptureTorchModeOn) {
    //
    //    }
    
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}
#pragma mark 懒加载
-(AVCaptureDevice *)device
{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return _device;
}
-(AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    
    return _session;
}

-(AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
        
    }
    
    return _input;
}

-(AVCaptureVideoDataOutput *)output
{
    if (_output == nil) {
        _output = [[AVCaptureVideoDataOutput alloc]init];
    }
    
    return _output;
}

-(void)dealloc
{
    [_session stopRunning];
    _session = nil;
}
@end

