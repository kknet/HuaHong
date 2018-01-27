//
//  UpLoadViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "UpLoadViewController.h"
#import "AppDelegate.h"

@interface UpLoadViewController ()<NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSURLSession *backgroundSession;

/**
 *  resumeData记录下载位置
 */
@property (nonatomic, strong) NSData* resumeData;
@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *backSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    backSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:backSwipe];
    
    UISwipeGestureRecognizer *uploadSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(uploadTask:)];
    uploadSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:uploadSwipe];
    
    UISwipeGestureRecognizer *downloadSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downloadTask:)];
    downloadSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downloadSwipe];
    
    
}

- (void)back:(UISwipeGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadTask:(UISwipeGestureRecognizer *)sender
{
    
    [self beginDownloadWithUrl:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
}

- (void)uploadTask:(UISwipeGestureRecognizer *)sender
{
    [self upDataFile];
    
}



- (void)upDataFile
{
    // 1. 创建URL
    NSString *urlStr = @"https://api.weibo.com/2/statuses/upload.json";
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 设置请求的为POST
    request.HTTPMethod = @"POST";
    
    // 3.构建要上传的数据
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"8" ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // 设置request的body
    request.HTTPBody = data;
    
    // 设置请求 Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    // 设置请求 Content-Type
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",@"Xia"] forHTTPHeaderField:@"Content-Type"];
    
    // 4. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //上传成功
            NSLog(@"上传成功");
        }else {
            // 上传失败, 打印error信息
            NSLog(@"error --- %@", error.localizedDescription);
        }
    }];
    // 恢复线程 启动任务
    [uploadTask resume];
}


#pragma mark - backgroundURLSession
- (NSURLSession *)backgroundURLSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"io.objc.backgroundTransferExample";
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        //NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    
    return session;
    
}

#pragma mark - Public Mehtod
- (void)beginDownloadWithUrl:(NSString *)downloadURLString {
    
    self.backgroundSession = [self backgroundURLSession];
    
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    //cancel last download task
    //    [self.downloadTask cancelByProducingResumeData:^(NSData * resumeData) {
    //
    //    }];
    
    self.downloadTask = [self.backgroundSession downloadTaskWithRequest:request];
    
    [self.downloadTask resume];
}

/**
 *  恢复下载
 */

- (void)resume
{
    // 传入上次暂停下载返回的数据，就可以恢复下载
    self.backgroundSession = [self backgroundURLSession];
    
    self.downloadTask = [self.backgroundSession downloadTaskWithResumeData:self.resumeData];
    
    [self.downloadTask resume]; // 开始任务
    
    self.resumeData = nil;
}

/**
 *  暂停
 */
- (void)pause
{
    __weak typeof(self) selfVc = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        //  resumeData : 包含了继续下载的开始位置\下载的url
        selfVc.resumeData = resumeData;
        selfVc.downloadTask = nil;
    }];
}
#pragma mark -- NSURLSessionDownloadDelegate
/**
 *  下载完毕会调用
 *
 *  @param location     文件临时地址
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    
    // 提示下载完成
    //    [[[UIAlertView alloc] initWithTitle:@"下载完成" message:downloadTask.response.suggestedFilename delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate initLocalNotification:@"下载完成"];
}

/**
 *  每次写入沙盒完毕调用
 *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
 *
 *  @param bytesWritten              这次写入的大小
 *  @param totalBytesWritten         已经写入沙盒的大小
 *  @param totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"downloadTask:%lu percent:%.2f%%",(unsigned long)downloadTask.taskIdentifier,(CGFloat)totalBytesWritten / totalBytesExpectedToWrite * 100);
    NSString *strProgress = [NSString stringWithFormat:@"%.2f",(CGFloat)totalBytesWritten / totalBytesExpectedToWrite];
    NSLog(@"strProgress:%@",strProgress);
}


//NSURLSessionDownloadDelegate
/**
 *  恢复下载后调用，
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
    NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
}



//NSURLSessionDelegate

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"Background URL session %@ finished events.\n", session);
    
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    [delegate initLocalNotification:@"DidFinishEventsForBackgroundURLSession"];
    
    if (session.configuration.identifier) {
        // 调用在 -application:handleEventsForBackgroundURLSession: 中保存的 handler
        //        [self callCompletionHandlerForSession:session.configuration.identifier];
    }
}


@end

