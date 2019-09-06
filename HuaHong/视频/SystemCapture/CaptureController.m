//
//  CaptureController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/8/21.
//  Copyright © 2019 huahong. All rights reserved.
//


#import "CaptureController.h"
#import "SystemCapture.h"

@interface CaptureController ()<SystemCaptureDelegate>
@property (nonatomic, strong) SystemCapture *capture;
@property (nonatomic, strong) CALayer *overLayer;
@property (nonatomic, strong) NSMutableDictionary *layerDic;
//@property (nonatomic, strong) NSFileHandle *handle;
//@property (nonatomic, copy) NSString *path;
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
    
//    //    测试写入文件
//    _path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"h264test.h264"];
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:_path]) {
//        if ([manager removeItemAtPath:_path error:nil]) {
//            NSLog(@"删除成功");
//            if ([manager createFileAtPath:_path contents:nil attributes:nil]) {
//                NSLog(@"创建文件");
//            }
//        }
//    }else {
//        if ([manager createFileAtPath:_path contents:nil attributes:nil]) {
//            NSLog(@"创建文件");
//        }
//    }
//
//    NSLog(@"%@", _path);
//    _handle = [NSFileHandle fileHandleForWritingAtPath:_path];
    
    
    
    [SystemCapture checkCameraAuthor];
    
    //捕获媒体
    _capture = [[SystemCapture alloc] initWithType:SystemCaptureTypeFace];
    CGSize size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    [_capture prepareWithPreviewSize:size];  //捕获视频时传入预览层大小
    _capture.preview.frame = CGRectMake(0, 120, size.width, size.height);
    [self.view addSubview:_capture.preview];
    self.capture.delegate = self;
    
    self.layerDic = [NSMutableDictionary dictionary];
    
    self.overLayer = [CALayer layer];
    self.overLayer.frame = _capture.preview.frame;
    self.overLayer.sublayerTransform = CATransform3DMakePerspective(1000);
    [_capture.preview.layer addSublayer:self.overLayer];
    
}


-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
//        if (metadataObjects.count)
//        {
//            AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
//            NSString *scanValue = metadataObject.stringValue;
//
//            [MBProgressHUD showInfo:scanValue toView:self.view];
//
//        }
    
    //黑名单
    NSMutableArray *blackList = [self.layerDic.allKeys mutableCopy];
    
    for (AVMetadataFaceObject *face in metadataObjects) {
        
        NSLog(@"face ID :%ld",face.faceID);
        NSLog(@"face bounds :%@",NSStringFromCGRect(face.bounds));
        
        NSNumber *faceID = @(face.faceID);
        [blackList removeObject:faceID];
        
        CALayer *layer = self.layerDic[faceID];
        if (layer == nil) {
            layer = [self makeFaceLayer];
            [self.overLayer addSublayer:layer];
            [self.layerDic setObject:layer forKey:faceID];
        }
        
        layer.transform = CATransform3DIdentity;
        
        if (face.hasRollAngle) {
            CATransform3D t = [self transformForRollAngle:face.rollAngle];
            layer.transform = CATransform3DConcat(layer.transform, t);
        }
        
        if (face.hasYawAngle) {
            CATransform3D t = [self transformForYawAngle:face.yawAngle];
            layer.transform = CATransform3DConcat(layer.transform, t);
        }
        
    }
    
    //移除上次存在的人脸，这次不存在
    for (NSNumber *faceID in blackList) {
        CALayer *layer = self.layerDic[faceID];
        [layer removeFromSuperlayer];
        [self.layerDic removeObjectForKey:faceID];
    }
    
}

- (CATransform3D)transformForRollAngle:(CGFloat)rollAngle
{
    //角度转弧度
    CGFloat rollAngleRadians = DegreesToRadians(rollAngle);
    return CATransform3DMakeRotation(rollAngleRadians, 0.0f, 0.0f, 1.0f);
}

- (CATransform3D)transformForYawAngle:(CGFloat)yawAngle
{
    //角度转弧度
    CGFloat yawAngleRadians = DegreesToRadians(yawAngle);
    CATransform3D t = CATransform3DMakeRotation(yawAngleRadians, 0.0f, -1.0f, 0.0f);
//    return CATransform3DConcat(t, <#CATransform3D b#>)
    
    return t;
}
- (CALayer *)makeFaceLayer
{
    CALayer *layer = [CALayer layer];
    layer.borderWidth = 5.0;
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.contents = (id)[UIImage imageNamed:@"mes_icon_sel"].CGImage;
    
    return layer;
}
//度数转为弧度(系统函数)
//static CGFloat DegreesToRadians(CGFloat degrees){
//
//    return degrees *M_PI /180;
//}

static CATransform3D CATransform3DMakePerspective(CGFloat eyePosition){
    
    CATransform3D transform = CATransform3DIdentity;
    
    //透视效果，近大远小
    transform.m34 = -1/eyePosition;
    
    return transform;
}
@end
