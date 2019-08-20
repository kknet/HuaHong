//
//  GPUImageController.m
//  HuaHong
//
//  Created by 华宏 on 2018/12/19.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "GPUImageController.h"
#import "GPUImage.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface GPUImageController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
@property (nonatomic, strong) GPUImageSaturationFilter *filter;
@property (nonatomic, strong) GPUImageView *GPUImgView;
@end

@implementation GPUImageController
{
    CGFloat value;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
    
    @weakify(self)
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@"http://sc0.hao123img.com/data/2017-02-23/1_78858744caabdeb66e298e1fa2077b24_510"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable sdImage, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = sdImage;
            
            value = 1.0;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"饱和度" style:(UIBarButtonItemStylePlain) target:self action:@selector(SketchFilter)];
            
        });
        
    }];
    
    
    
    
    
    
   
}

/** 饱和度滤镜 */
- (void)adjustSaturation
{
     UIImage *image = self.imageView.image;
    
    if (!_filter) {
        _filter = [[GPUImageSaturationFilter alloc]init];
    }

    value += 0.5;
    _filter.saturation = value;

    [_filter forceProcessingAtSize:image.size];
    [_filter useNextFrameForImageCapture];//use

    GPUImagePicture *stillImage = [[GPUImagePicture alloc]initWithImage:image];
    [stillImage addTarget:_filter];
    [stillImage processImage];//处理

    UIImage *newImage = [_filter imageFromCurrentFramebuffer];

    self.imageView.image = newImage;
    
}

/** 黑白滤镜 */
- (void)SketchFilter
{
    UIImage *image = self.imageView.image;
   

    GPUImageSketchFilter *SketchFilter = [[GPUImageSketchFilter alloc]init];
    
    [SketchFilter forceProcessingAtSize:image.size];
    [SketchFilter useNextFrameForImageCapture];
    
    GPUImagePicture *stillImage = [[GPUImagePicture alloc]initWithImage:image];
    [stillImage addTarget:SketchFilter];
    [stillImage processImage];
    
    UIImage *newImage = [SketchFilter imageFromCurrentFramebuffer];
    
    self.imageView.image = newImage;
}

/** 静态相机拍照 */
- (void)customeCamera
{
    _stillCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:(AVCaptureDevicePositionBack)];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _filter = [[GPUImageSaturationFilter alloc]init];
    _filter.saturation = 1.5;
    _GPUImgView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    [_stillCamera addTarget:_filter];
    [_filter addTarget:_GPUImgView];
    [_stillCamera startCameraCapture];
    [self.view addSubview:_GPUImgView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(save)];
}
- (void)save
{
    [_stillCamera capturePhotoAsJPEGProcessedUpToFilter:_filter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        
        UIImage *image = [UIImage imageWithData:processedJPEG];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
        }];
    }];
    
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = self.view.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _imageView;
}

-(void)imageStretch
{
    UIImage *image = [UIImage imageNamed:@"flash"];
    
    /**
     * 这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片
     *LeftCapWidth:左边不拉伸区域的宽度
     *topCapHeight:上面不拉伸的高度
     */
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    //将图片显示出来
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    imageView.image = image;
    [self.view addSubview:imageView];
}
@end
