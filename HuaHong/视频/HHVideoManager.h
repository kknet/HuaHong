//
//  HHVideoManager.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHVideoManager : NSObject

//判断相机权限
+(BOOL)cameraAuthStatus;

//判断设备是否有摄像头
+(BOOL)isCameraAvailable;

//前摄像头是否可用
+(BOOL)isFrontCameraAvailable;

//后摄像头是否可用
+(BOOL)isRearCameraAvailable;

// 判断是否支持某种多媒体类型：拍照，视频
+(BOOL)cameraSupportsMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType;

//检查摄像头是否支持录像
+(BOOL)cameraSupportShootingVideos;

//检查摄像头是否支持拍照
+(BOOL)cameraSupportTakingPhotos;

//是否可以在相册中选择视频
+(BOOL)canPickVideosFromPhotoLibrary;

//是否可以在相册中选择照片
+(BOOL)canPickPhotoFromPhotoLibrary;

//用来返回是前置摄像头还是后置摄像头
+ (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position;

//返回后置摄像头
+ (AVCaptureDevice *)backCamera;

//返回前置摄像头
+ (AVCaptureDevice *)frontCamera;

/**
 视频添加水印
 
 @param videoPath 源路径
 @param watermark 水印
 @param complete 完成回调
 */
+(void)saveVideoPath:(NSURL*)videoPath
           Watermark:(NSString*)watermark
            complete:(void (^)(NSURL *outputURL))complete;

//视频合成
+(void)addFirstVideo:(NSURL*)firstVideoPath andSecondVideo:(NSURL*)secondVideo withMusic:(NSURL*)musicPath;

//保存到相册
+(void)saveToPhotoLibrary:(NSURL *)fileUrl;

//+(void)saveVedioPath:(NSURL*)vedioPath WithQustion:(NSString*)question WithFileName:(NSString*)fileName;

//获得视频存放地址
+(NSString *)getVideoCachePath;

//开启／关闭闪光灯
+(void)switchFlashLight;

//获取视频时长
+ (CGFloat)getVideoLength:(NSURL *)URL;

//获取视频大小
+ (CGFloat)getFileSize:(NSString *)path;

//转MP4 压缩视频
+ (void)changeMovToMp4:(NSURL *)mediaURL;

@end

