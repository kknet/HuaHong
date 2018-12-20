//
//  HHVideoManager.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/13.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHVideoManager.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation HHVideoManager

//判断相机权限
+(BOOL)cameraAuthStatus
{
    AVAuthorizationStatus *authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

//判断设备是否有摄像头 /UIImagePickerControllerSourceTypePhotoLibrary /UIImagePickerControllerSourceTypeSavedPhotosAlbum
+(BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//前面的摄像头是否可用
+(BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

//后面的摄像头是否可用
+(BOOL)isRearCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//用来返回是前置摄像头还是后置摄像头
+ (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//返回前置摄像头
+ (AVCaptureDevice *)frontCamera {
    return [HHVideoManager cameraWithPosition:AVCaptureDevicePositionFront];
}

//返回后置摄像头
+ (AVCaptureDevice *)backCamera {
    return [HHVideoManager cameraWithPosition:AVCaptureDevicePositionBack];
}

// 判断是否支持某种多媒体类型：拍照，视频
+(BOOL)cameraSupportsMedia:(NSString *)mediaType sourceType:(UIImagePickerControllerSourceType)sourceType
{
    __block BOOL result = NO;
    if (mediaType.length == 0) {
        return NO;
    }
    
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = (NSString *)obj;
        if ([type isEqualToString:mediaType]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

//检查摄像头是否支持录像
+(BOOL)cameraSupportShootingVideos
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

//检查摄像头是否支持拍照
+(BOOL)cameraSupportTakingPhotos
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

//是否可以在相册中选择视频
+(BOOL)canPickVideosFromPhotoLibrary
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeVideo sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

//是否可以在相册中选择照片
+(BOOL)canPickPhotoFromPhotoLibrary
{
    return [self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

+(void)saveVideoPath:(NSURL*)videoPath Watermark:(NSString*)watermark complete:(void (^)(NSURL *outputURL))complete
{
    if (!videoPath) {
        return;
    }
    
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    //封面图片
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(YES) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoPath options:opts];     //初始化视频媒体文件
    CMTime startTime = CMTimeMakeWithSeconds(0.2, 600);
    CMTime endTime = CMTimeMakeWithSeconds(videoAsset.duration.value/videoAsset.duration.timescale-0.2, videoAsset.duration.timescale);
    //声音采集
    AVURLAsset * audioAsset = [[AVURLAsset alloc] initWithURL:videoPath options:opts];
    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
    if ([videoAsset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        return;
    }
    [videoTrack insertTimeRange:CMTimeRangeMake(startTime, endTime)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    //音频通道
    AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频采集通道
    AVAssetTrack * audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [audioTrack insertTimeRange:CMTimeRangeMake(startTime, endTime) ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration);
    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        //        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    //    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
    //        videoAssetOrientation_ =  UIImageOrientationUp;
    //    }
    //    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
    //        videoAssetOrientation_ = UIImageOrientationDown;
    //    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:endTime];
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 25);
    
    
    //    [HLCameraTool applyVideoEffectsToComposition:mainCompositionInst WithQustion:question size:CGSizeMake(renderWidth, renderHeight)];
    
    [self applyVideoEffectsToComposition:mainCompositionInst Watermark:watermark size:CGSizeMake(renderWidth, renderHeight)];
    
    
    // 4 - 输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",@"qkWaterVideo"]];
    unlink([myPathDocs UTF8String]);
    NSURL* videoUrl = [NSURL fileURLWithPath:myPathDocs];
    //    CADisplayLink *dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    //    [dlink setFrameInterval:15];
    //    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    //    [dlink setPaused:NO];
    
    
    // 5 - 视频文件输出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=videoUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //这里是输出视频之后的操作，做你想做的
            complete(videoUrl);
        });
    }];}

#pragma mark AVFoundation水印
+(void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition Watermark:(NSString*)watermark size:(CGSize)size
{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:watermark attributes:@{
                                                                                                               
                                                                                                               NSFontAttributeName : [UIFont systemFontOfSize: 30],
                                                                                                               NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                                                               }];
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    [textLayer setString:attr];
    //    textLayer.contentsScale = [UIScreen mainScreen].scale;
    //    [textLayer setAlignmentMode:kCAAlignmentCenter];
    //    textLayer.truncationMode = kCATruncationNone;
    textLayer.masksToBounds = YES;
    [textLayer setWrapped:YES];
    [textLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    
    
    //计算文本位置
    
    CGRect textRect = [attr boundingRectWithSize:CGSizeMake(size.width - 10*2 , size.height / 2) options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading context:nil];
    
    
    CGFloat textLayer_X = (size.width - textRect.size.width) / 2;
    CGFloat textLayer_Y = 100;
    
    CGFloat textLayer_W = textRect.size.width;
    CGFloat textLayer_H = textRect.size.height + 10;
    
    CGRect textLayerFrame = CGRectMake(textLayer_X, textLayer_Y, textLayer_W, textLayer_H);
    
    [textLayer setFrame:textLayerFrame];
    
    
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:textLayer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    //    textLayer.contentsCenter = overlayLayer.contentsCenter;
    
    NSLog(@"overlayLayer == %@",overlayLayer);
    [overlayLayer setMasksToBounds:YES];
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:
                                 videoLayer inLayer:parentLayer];
    
    
    
}

#pragma mark 视频合成
+(void)addFirstVideo:(NSURL*)firstVideoPath andSecondVideo:(NSURL*)secondVideo withMusic:(NSURL*)musicPath{
    
    [SVProgressHUD showWithStatus:@"正在合成视频"];
    
    AVAsset *firstAsset = [AVAsset assetWithURL:firstVideoPath];
    AVAsset *secondAsset = [AVAsset assetWithURL:secondVideo];
    AVAsset *musciAsset = [AVAsset assetWithURL:musicPath];
    
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *firstVideoTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, firstAsset.duration)
                        ofTrack:firstVideoTrack atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *secondVideoTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    [videoTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, secondAsset.duration)
                        ofTrack:secondVideoTrack atTime:firstAsset.duration error:nil];
    
    AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    if (musciAsset)
    {
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
                            ofTrack:[[musciAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
    }else
    {
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero,  firstAsset.duration)
                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:kCMTimeZero error:nil];
        [AudioTrack insertTimeRange:CMTimeRangeFromTimeToTime(kCMTimeZero,  secondAsset.duration)
                            ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] firstObject] atTime:firstAsset.duration error:nil];
    }
    
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    
    //    NSString *path = [HLCameraTool getVideoSaveFilePathString];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    
    // 5 - 视频导出
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    
    //修改背景音乐的音量start
    AVMutableAudioMix *videoAudioMixTools = [AVMutableAudioMix audioMix];
    //    if (musciAsset) {
    //调节音量
    //获取音频轨道
    AVMutableAudioMixInputParameters *firstAudioParam = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:AudioTrack];
    //设置音轨音量,可以设置渐变,设置为1.0就是全音量
    [firstAudioParam setVolumeRampFromStartVolume:1.0 toEndVolume:1.0 timeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))];
    [firstAudioParam setTrackID:AudioTrack.trackID];
    videoAudioMixTools.inputParameters = [NSArray arrayWithObject:firstAudioParam];
    //    }
    //end
    
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.audioMix = videoAudioMixTools;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self exportDidFinish:exporter];
        });
    }];
    
    
}

+ (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //保存到相册
            [self saveToPhotoLibrary:outputURL];
            
        });
    }
}

+(void)saveToPhotoLibrary:(NSURL *)fileUrl
{
    
    //方式一
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
            [SVProgressHUD showSuccessWithStatus:@"已保存到相册"];
        }
    }];
    
    //方式二
    /*
     __block PHObjectPlaceholder *placeholder;
     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(fileUrl.path))
     {
     NSError *error;
     [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
     PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl];
     placeholder = [createAssetRequest placeholderForCreatedAsset];
     } error:&error];
     if (error) {
     
     }
     
     }
     */
    
}

//获得视频存放地址
+(NSString *)getVideoCachePath
{
    NSString *docpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *videoCache = [docpath stringByAppendingPathComponent:@"vodeos"];
    BOOL isDir = NO;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL exited = [filemanager fileExistsAtPath:videoCache isDirectory:&isDir];
    if (!(isDir == YES && exited == YES)) {
        [filemanager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *videoName = [self getUploadFile_type:@"video" fileType:@"mp4"];
    videoCache = [videoCache stringByAppendingPathComponent:videoName];
    
    return videoCache;
}

+ (NSString *)getUploadFile_type:(NSString *)type fileType:(NSString *)fileType {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.%@",type,timeStr,fileType];
    return fileName;
}

+ (void)cleanCache:(NSString *)videoPath
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        //删除
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSLog(@"录制意外结束，删除本地文件");
    }
    NSAssert([[NSThread mainThread] isMainThread], @"Not Main Thread");
    
}

//开启／关闭闪光灯
+(void)switchFlashLight
{
    //    AVCaptureDevice *backCamera = [VideoManager backCamera];
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (backCamera.torchMode == AVCaptureTorchModeOff) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOn;
        backCamera.flashMode = AVCaptureFlashModeOn;
        [backCamera unlockForConfiguration];
    } else {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOff;
        backCamera.flashMode = AVCaptureTorchModeOff;
        [backCamera unlockForConfiguration];
    }
    
    
}

//获取视频时长
+ (CGFloat)getVideoLength:(NSURL *)URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

//获取视频大小
+ (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    }
    return filesize;
}

//转MP4 压缩视频
+ (void)changeMovToMp4:(NSURL *)mediaURL
{
    AVAsset *video = [AVAsset assetWithURL:mediaURL];
    
    /**
     * presetName： 视频质量
     */
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:video presetName:AVAssetExportPresetLowQuality];
    
//    指示输出文件应使用网络优化
//    exportSession.shouldOptimizeForNetworkUse = YES;
    
    //设置输出文件类型
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    //设置输出路径
    NSString * basePath=[self getVideoCachePath];
    exportSession.outputURL = [NSURL fileURLWithPath:basePath];
    
    //导出
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
    }];
}


//#pragma mark GPUImage水印
//+(void)saveVedioPath:(NSURL*)vedioPath WithQustion:(NSString*)question WithFileName:(NSString*)fileName
//{
//    //    [SVProgressHUD showWithStatus:@"生成水印视频到系统相册"];
//    // 滤镜
//    //    filter = [[GPUImageDissolveBlendFilter alloc] init];
//    //    [(GPUImageDissolveBlendFilter *)filter setMix:0.0f];
//    //也可以使用透明滤镜
//    //    filter = [[GPUImageAlphaBlendFilter alloc] init];
//    //    //mix即为叠加后的透明度,这里就直接写1.0了
//    //    [(GPUImageDissolveBlendFilter *)filter setMix:1.0f];
//
//    GPUImageOutput<GPUImageInput> *filter = [[GPUImageNormalBlendFilter alloc] init];
//
//    NSURL *sampleURL  = vedioPath;
//    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
//    CGSize size = asset.naturalSize;
//
//    GPUImageMovie *movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
//    movieFile.playAtActualSpeed = NO;
//
//    // 文字水印
//    UILabel *label = [[UILabel alloc] init];
//    label.text = question;
//    label.font = [UIFont systemFontOfSize:30];
//    label.textColor = [UIColor whiteColor];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label sizeToFit];
//    label.layer.masksToBounds = YES;
//    label.layer.cornerRadius = 18.0f;
//    [label setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
//    [label setFrame:CGRectMake(50, 100, label.frame.size.width+20, label.frame.size.height)];
//
//    //    //图片水印
//    //    UIImage *coverImage1 = [img copy];
//    //    UIImageView *coverImageView1 = [[UIImageView alloc] initWithImage:coverImage1];
//    //    [coverImageView1 setFrame:CGRectMake(0, 100, 210, 50)];
//    //
//    //    //第二个图片水印
//    //    UIImage *coverImage2 = [coverImg copy];
//    //    UIImageView *coverImageView2 = [[UIImageView alloc] initWithImage:coverImage2];
//    //    [coverImageView2 setFrame:CGRectMake(270, 100, 210, 50)];
//
//    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    subView.backgroundColor = [UIColor clearColor];
//
//    //    [subView addSubview:coverImageView1];
//    //    [subView addSubview:coverImageView2];
//    [subView addSubview:label];
//
//
//    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
//    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",fileName]];
//    unlink([pathToMovie UTF8String]);
//    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
//
//    GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(720.0, 1280.0)];
//
//    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
//    [progressFilter addTarget:filter];
//    [movieFile addTarget:progressFilter];
//    [uielement addTarget:filter];
//    movieWriter.shouldPassthroughAudio = YES;
//    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
//        movieFile.audioEncodingTarget = movieWriter;
//    } else {//no audio
//        movieFile.audioEncodingTarget = nil;
//    }
//    //    movieFile.playAtActualSpeed = true;
//    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
//    // 显示到界面
//    [filter addTarget:movieWriter];
//
//    [movieWriter startRecording];
//    [movieFile startProcessing];
//
//    //    dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//    //    [dlink setFrameInterval:15];
//    //    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    //    [dlink setPaused:NO];
//
//    //    __weak typeof(self) weakSelf = self;
//    //渲染
//    //    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
//    //        //水印可以移动
//    //        CGRect frame = coverImageView1.frame;
//    //        frame.origin.x += 1;
//    //        frame.origin.y += 1;
//    //        coverImageView1.frame = frame;
//    //        //第5秒之后隐藏coverImageView2
//    //        if (time.value/time.timescale>=5.0) {
//    //            [coverImageView2 removeFromSuperview];
//    //        }
//    //        [uielement update];
//    //
//    //    }];
//
//    //保存相册
//    //    [movieWriter setCompletionBlock:^{
//    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //            __strong typeof(self) strongSelf = weakSelf;
//    //            [strongSelf->filter removeTarget:strongSelf->movieWriter];
//    //            [strongSelf->movieWriter finishRecording];
//    //            __block PHObjectPlaceholder *placeholder;
//    //            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
//    //            {
//    //                NSError *error;
//    //                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
//    //                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:movieURL];
//    //                    placeholder = [createAssetRequest placeholderForCreatedAsset];
//    //                } error:&error];
//    //
//    //            }
//    //        });
//    //    }];
//}
//
@end

