//
//  AFController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AFController.h"
#import <AFHTTPSessionManager.h>
#import "HHRequestManager.h"
#import "NSDictionary+Null.h"
@interface AFController ()

@end

@implementation AFController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self GetRequest];
    
//    [self PostRequest];
    
//    [self uploadFile];
    [[HHRequestManager defaultManager] setReachablityUrl:@"https://www.baidu.com"] ;
    [[HHRequestManager defaultManager] setFilterResponseCallback:^(NSDictionary  *_Nonnull data, void (^ _Nonnull continueResponseBlock)(id _Nonnull)) {

        continueResponseBlock([data filterNull]);
    }];
    
    [[HHRequestManager defaultManager]requestDataByUrl:^NSString * _Nonnull{
        return @"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree";
    } withParams:^id _Nonnull{
        return @{@"userId":@8};
    } withHttpType:^HHRequestType{
        return HHRequestPOST;
    } withProgress:^(id _Nonnull progress) {
        NSLog(@"progress:%@",progress);

    } withResultBlock:^(id _Nonnull result) {

    } withErrorBlock:^(HHRequestErrorType error) {

    } isSupportHud:YES isSupportErrorAlert:YES];
    
    
}

-(void)uploadFile
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"weixinY.mp4" withExtension:nil];
    
    [[AFHTTPSessionManager manager]POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件
        [formData appendPartWithFileURL:fileUrl name:@"AFNUpload" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)PostRequest
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"demo.json"];
    
    [[AFHTTPSessionManager manager]POST:urlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);

    }];
}
-(void)GetRequest
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"demo.json"];

    [[AFHTTPSessionManager manager]GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);

    }];
}

@end
