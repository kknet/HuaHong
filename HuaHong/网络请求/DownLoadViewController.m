//
//  DownLoadViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DownLoadViewController.h"
#import "ProgressView.h"

@interface DownLoadViewController ()<NSURLSessionDownloadDelegate>
@property (strong, nonatomic) IBOutlet ProgressView *progressView;
@property(nonatomic,strong) NSURLSession *session;
@property(nonatomic,strong) NSURLSessionDownloadTask *downloadTask;
@property(nonatomic,strong) NSData *resumeData;
@end

@implementation DownLoadViewController
// 配置NSURLSessionConfiguration属性
/**
 *defaultSessionConfiguration 使用磁盘缓存，账户信息存储到钥匙串，若有则携带cookie
 *ephemeralSessionConfiguration 与上面相反
 *backgroundSessionConfigurationWithIdentifier 在一个单独的进程上下载，app进入后台或终止后仍可下载
 */
/*
 requestCachePolicy：设置缓存策略
 networkServiceType：设置网络服务的类型：网络流量，网络电话，语音，视频..
 timeoutIntervalForRequest：设置超时时间
 HTTPAdditionalHeaders：设置请求头
 discretionary：用于后台请求，会把WiFi和电量的可用性考虑在内
 allowsCellularAccess：是否允许使用蜂窝数据
 */
-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _session;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /**
     * @property (nullable, readonly, retain) id <NSURLSessionDelegate> delegate;
     * delegate 是强引用，会造成循环引用
     */
    
    //取消任务并且使session无效
    [self.session invalidateAndCancel];
    
    //任务完成再使session无效
    //    [self.session finishTasksAndInvalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)downLoad
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"tanzhou/images.zip"];
    NSURL *url = [NSURL URLWithString:urlStr];

    [[self.session downloadTaskWithURL:url]resume];
    
    
    //    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        NSLog(@"location:%@",location);
    //    [self unZip:location];
    
    //
    //    }]resume];
    
}

//解压缩
-(void)unZip:(NSURL *)location
{
    /**
     * 1.不做任何处理，下载的文件会被删除
     * 2.默认下载到tmp文件夹
     * 3.网络下载的文件通常是zip格式，需要解压，解压后，zip文件会被删除
     */
    
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//    [SSZipArchive unzipFileAtPath:location.path toDestination:path];
}

#pragma mark - delegate
//下载完成
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成");
    [self.session finishTasksAndInvalidate];
    self.session = nil;
    
//    [self unZip:location];
}

//下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    /**
     bytesWritten                本次下载的字节数
     totalBytesWritten           已下载的字节数
     totalBytesExpectedToWrite   总大小
     
     */
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"progress:%.2f",progress);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

/**
 *  恢复下载后调用，
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
}

- (IBAction)downLoadAction:(UIButton *)sender
{
//    [self downLoad];
}

#pragma mark - 断点续传
- (IBAction)start:(id)sender
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"tanzhou/images.zip"];
    NSURL *url = [NSURL URLWithString:urlStr];
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}
- (IBAction)pause:(id)sender
{
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
        self.resumeData = resumeData;
        self.downloadTask = nil;
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
        [self.resumeData writeToFile:path atomically:YES];
    }];
}
- (IBAction)resume:(id)sender
{
    if (self.downloadTask) {
        return;
    }
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        self.resumeData = [NSData dataWithContentsOfFile:path];
    }
    
    if (self.resumeData == nil) {
        return;
    }
   self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    self.resumeData = nil;
    
    

}
- (IBAction)stop:(id)sender
{
    if (self.downloadTask)
    {
        [self.downloadTask cancel];
        self.downloadTask = nil;
        
    }
    
}

-(void)writeFileData:(NSData *)data
{
    /*
     NSFileManager: 主要功能，创建目录、检查目录是否存在，遍历目录、删除文件、拷贝文件、针对文件的操作
     NSFileHandle: 文件“句柄”，对文件的操作！ 主要功能：就同一个文件进行二进制读写
     
     
     判断文件是否下载完成！
     1.判断进度？判断完成通知？
     2.判断时间、判断大小？
     3.MD5
     
     1.服务器会对你的下载文件 计算好一个MD5 将此MD5 传给客户端；
     2.开始下载文件。。。。。
     3.下载完成时，对下载的文件做一次MD5
     4.比较服务器返回的MD5 和你 自己计算的MD5 比较 == 下载完成！
     
     */
    
    
    NSString *_tartgetFilePath = @"";
    NSFileHandle *fp = [NSFileHandle fileHandleForWritingAtPath:_tartgetFilePath];
    
    //如果文件不存在,直接将数据写入磁盘
    if (fp == nil) {
        
        [data writeToFile:_tartgetFilePath atomically:YES];
        
    }else
    {
        //如果存在，将data追加到现在文件的末尾
        [fp seekToEndOfFile];
        //写入文件
        [fp writeData:data];
        //关闭文件
        [fp closeFile];
        
    }
}

-(void)OutputStream:(NSData *)data
{
    NSString *_tartgetFilePath = @"";

    //1.创建输出流
   NSOutputStream *_fileStream = [[NSOutputStream alloc]initToFileAtPath:_tartgetFilePath append:YES];
    [_fileStream open];
    
    //判断是否有空间可写
    if ([_fileStream  hasSpaceAvailable]) {
        [_fileStream write:data.bytes maxLength:data.length];
    }
    
    //关闭文件流
    [_fileStream close];
}
@end

