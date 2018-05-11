//
//  RequestController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/19.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "SessionRequestController.h"

@interface SessionRequestController ()<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property (nonatomic,strong) NSURLSession *session;

@end

@implementation SessionRequestController

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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadData_Session_POST2];
}


//使用代理
-(void)loadData_Session_POST2
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"demo.json"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
//    [request setHTTPMethod:@"GET"];
//    NSString *bodytext = @"hsdbhhaa";
//    NSData *body = [bodytext dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:body];
    
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url];
    
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
// 1.服务器返回响应头信息，注意：这时候相应体中的数据还没有传输完成
-(void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 1>取得响应包对象
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    // 2>取得响应头信息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
    NSLog(@"响应头：%@", allHeaderFields);
    
    //选择是否继续本次回话，NSURLSessionResponseDisposition枚举值有三个选项
    completionHandler(NSURLSessionResponseAllow);
}

// 2.响应体的数据接收完成
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // data接收到的网络数据
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"响应体-接收到的网络数据：%@", dataString);
}

// 3.任务加载完成
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if(error ==nil) {
        NSLog(@"任务完成");
    }else{
        NSLog(@"error : %@", error);
    }
}




@end
