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
#import "QKRequestManager.h"

@interface AFController ()

@end

@implementation AFController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [[QKRequestManager defaultManager] startNetMonitoring];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
//    [[QKRequestManager defaultManager] setFilterResponseCallback:^(NSDictionary  *_Nonnull data, void (^ _Nonnull continueResponseBlock)(id _Nonnull)) {
//
//        continueResponseBlock([data filterNull]);
//    }];
    
    
    [[QKRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{@"userId":@"8"} requestType:QKRequestPOST progress:nil
    success:^(id  _Nonnull responseObject) {

    } failure:^(QKRequestErrorType error) {

    } isSupportHud:YES isSupportErrorAlert:YES];
    
    
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/QQ_V6.5.3.dmg"];
//    [[QKRequestManager defaultManager]download:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.3.dmg" downloadPath:path progress:^(NSProgress * _Nonnull progress) {
// 
//        dispatch_async(dispatch_get_main_queue(), ^{
//            CGFloat percent = progress.completedUnitCount/(CGFloat)progress.totalUnitCount;
//            [SVProgressHUD showProgress:percent status:@"下载进度"];
//        });
//
//
//    } success:^(NSString * _Nonnull filePath) {
//        NSLog(@"download complate");
//        [SVProgressHUD dismiss];
//    } failure:^(QKRequestErrorType error) {
//
//    } isSupportHud:NO isSupportErrorAlert:YES];
    
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
