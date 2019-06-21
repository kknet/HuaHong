//
//  HttpsController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HttpsController.h"

@interface HttpsController ()<NSURLSessionTaskDelegate>

@end

@implementation HttpsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self httpsRequest];
}


-(void)httpsRequest
{
    //https
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/index/init"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    //    [request setHTTPMethod:@"POST"];
    //    NSString *bodytext = @"hsdbhhaa";
    //    NSData *body = [bodytext dataUsingEncoding:NSUTF8StringEncoding];
    //    [request setHTTPBody:body];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *value = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"value:%@",value);
        
    }];
    
    [task resume];
}

//https 证书
/*
 challenge ：询问，询问客户端是否需要信任来自服务器的证书
 protectionSpace 受保护的空间
 
 completionHandler：通过代码块回调，决定对证书的处理！
 
 NSURLSessionAuthChallengeUseCredential = 0, 使用服务器发回的证书，并且保存到challenge 中
 NSURLSessionAuthChallengePerformDefaultHandling = 1,默认处理方式，会忽略证书
 NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 取消整个请求，并忽略证书
 NSURLSessionAuthChallengeRejectProtectionSpace = 3,本次拒绝，下次再试
 
 
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
     //1.判断服务器的身份验证是，信任服务器证书
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        
        //2.获取证书
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        //3.对服务器的证书来进行处理
        completionHandler(0,credential);
    }
}

@end
