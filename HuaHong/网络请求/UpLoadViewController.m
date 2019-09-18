//
//  UpLoadViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "UpLoadViewController.h"

@interface UpLoadViewController ()

@property (nonatomic,strong) NSURLSession *session;

@end

@implementation UpLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //统一设置请求头信息
        //        config.HTTPAdditionalHeaders = @{@"Authorization":[self getAuthorization:@"admin" pwd:@"901124"]};
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue new]];
        
    }
    
    return _session;
}

#pragma mark - put 上传文件
-(void)uploadData_SessionPUT
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    [request setHTTPMethod:@"put"];
    
    //Authorization    Basic YWRtaW46OTAxMTI0
    [request setValue:[self getAuthorization:@"admin" pwd:@"901124"]forHTTPHeaderField:@"Authorization"];
    
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"video.mov" withExtension:nil];
    
    //此方法没有代理
    /*
     [[[NSURLSession sharedSession]uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
     NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"data:%@",str);
     
     }]resume];
     
     */
    
    
    //    [[self.session uploadTaskWithRequest:request fromFile:fileUrl]resume];
    
    //此方法也可设置代理
    [[self.session uploadTaskWithRequest:request fromFile:fileUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"--data:%@",str);
        NSLog(@"--response:%@",response);
        
        
    }]resume];
}

-(NSString *)getAuthorization:(NSString *)userName pwd:(NSString *)pwd
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@:%@",userName,pwd];
    tmpStr = [tmpStr base64Encode];
    NSString *authorizationStr = [NSString stringWithFormat:@"Basic %@",tmpStr];
    return authorizationStr;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self upDataFile];
    
    [self uploadData_SessionPUT];

}

//测试
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



@end

