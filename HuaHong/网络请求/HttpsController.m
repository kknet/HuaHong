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
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(0,credential);
    }
}

@end
