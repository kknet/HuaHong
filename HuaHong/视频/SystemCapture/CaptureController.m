//
//  CaptureController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/21.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "CaptureController.h"
#import "CCSystemCapture.h"

@interface CaptureController ()<SystemCaptureDelegate>
@property (nonatomic, strong) CCSystemCapture *capture;
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, copy) NSString *path;
@end

@implementation CaptureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"testVideo";
    
    [self testVideo];
    
    [self.capture startRunning];
}

- (IBAction)startAction:(id)sender {
    
}

- (IBAction)stopAction:(id)sender {
    [self.capture stopMovieRecording];
}
- (IBAction)switchAction:(id)sender {
    [self.capture switchCamera];
}
- (IBAction)otherAction:(id)sender {
//     [_handle closeFile];
    [self.capture startMovieRecording];
}


- (void)testVideo {
    
    //    测试写入文件
    _path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"h264test.h264"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_path]) {
        if ([manager removeItemAtPath:_path error:nil]) {
            NSLog(@"删除成功");
            if ([manager createFileAtPath:_path contents:nil attributes:nil]) {
                NSLog(@"创建文件");
            }
        }
    }else {
        if ([manager createFileAtPath:_path contents:nil attributes:nil]) {
            NSLog(@"创建文件");
        }
    }
    
    NSLog(@"%@", _path);
    _handle = [NSFileHandle fileHandleForWritingAtPath:_path];
    [CCSystemCapture checkCameraAuthor];
    
    //捕获媒体
    _capture = [[CCSystemCapture alloc] initWithType:SystemCaptureTypeMetadata];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    [_capture prepareWithPreviewSize:size];  //捕获视频时传入预览层大小
    _capture.preview.frame = CGRectMake(0, 120, size.width, size.height);
    [self.view addSubview:_capture.preview];
    self.capture.delegate = self;
    
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //    if (metadataObjects.count)
    //    {
    //        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
    //        NSString *scanValue = metadataObject.stringValue;
    //        [_session stopRunning];
    //        [self showMessage:scanValue];
    //
    //    }
    
//    if (_delegate && [_delegate respondsToSelector:@selector(captureOutput:didOutputMetadataObjects:fromConnection:)]) {
//        [_delegate captureOutput:output didOutputMetadataObjects:metadataObjects fromConnection:connection];
//    }
}
@end
