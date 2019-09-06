//
//  QRCordeController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/4.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QRCodeController.h"
#import <Photos/PHPhotoLibrary.h>
#import "ScanView.h"

@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation QRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isAvailableCamera]) {
        
        [self setUpQRCorde];
    }
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhotoLibrary)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)setUpQRCorde
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //自动聚焦
    if (_device.autoFocusRangeRestrictionSupported) {
        if ([_device lockForConfiguration:nil]) {
            _device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            
            [_device unlockForConfiguration];
        }
    }
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    _output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypeQRCode];
    
    //自动聚焦
    [self focusForQRCode];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.frame = self.view.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    [_session startRunning];
    
    ScanView *_scanView = [[ScanView alloc]initWithFrame:self.view.bounds];
    _scanView.scanAreaSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-60*2, [UIScreen mainScreen].bounds.size.width-60*2);
    _scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scanView];
    
}

- (void)focusForQRCode
{
    //自动聚焦
    AVCaptureDevice *device = _input.device;
    NSError *error;
    
    if ([device lockForConfiguration:&error]) {
        if (device.autoFocusRangeRestrictionSupported) {
            device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
            
            [device unlockForConfiguration];
        }
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count)
    {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSString *scanValue = metadataObject.stringValue;
        [_session stopRunning];
        [self showMessage:scanValue];
        
    }
}

#pragma mark - 从相册选择
-(void)openPhotoLibrary
{
    if (![self isAvailableAlbum]) {
        [self showMessage:@"无权限打开相册"];
        return;
    }
    
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.delegate = self;
    pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pick.allowsEditing = YES;
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self scanAlbumImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 扫描相册图片
-(void)scanAlbumImage:(UIImage *)image
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count)
    {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scanResult = feature.messageString;
        
        [self showMessage:scanResult];
        
    }
}

-(void)showMessage:(NSString *)message
{
    [UIViewController showAlertWhithTarget:self Title:@"扫描结果" Message:message ClickAction:^(UIAlertController *alertCtrl, NSInteger buttonIndex) {
        
    } CancelTitle:@"确定" OtherTitles: nil];
}

-(BOOL)isAvailableCamera
{
  //是否有摄像头，是否有使用权限
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            
            [self showMessage:@"相机无使用权限"];
            return NO;
        }else
        {
            return YES;
        }
        
    }else
    {
        [self showMessage:@"无摄像头"];
        return NO;
    }
    
}

-(BOOL)isAvailableAlbum
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        return NO;
    }
    
    return YES;
}
@end
