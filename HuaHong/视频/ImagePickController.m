//
//  ImagePickController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/7.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "ImagePickController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePickController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@end

@implementation ImagePickController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UIImagePickerController";
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![HHVideoManager isCameraAvailable] || ![HHVideoManager cameraSupportShootingVideos] || ![HHVideoManager cameraAuthStatus]) {
        return;
    }
    
    UIImagePickerController *pick = [[UIImagePickerController alloc]init];
    pick.delegate = self;
    
    pick.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //设置媒体类型
    pick.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    //设置相机检测模式
    pick.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    //设置视频质量
    pick.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //是否允许编辑
    pick.allowsEditing = YES;
    
    //最大时长
    pick.videoMaximumDuration = 10;
    
    [self presentViewController:pick animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        //image
        UIImage *image;
        if ([picker allowsEditing]) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else
        {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        // 保存图片到相册中
        SEL saveFinishSEL = @selector(saveFinished:error:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(image, self, saveFinishSEL, nil);
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //video
        NSURL *mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        //将视频保存到媒体库
        [HHVideoManager saveToPhotoLibrary:mediaUrl];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)saveFinished:(UIImage *)image error:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        NSLog(@"保存失败:%@",error);
    }else
    {
        NSLog(@"保存成功");

    }
}
@end
