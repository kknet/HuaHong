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
@property (strong, nonatomic) NSURLSessionTask *task;
@end

@implementation AFController


- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)testMethod {
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];

    [self requestData];
    [MBProgressHUD showMessage:@"message"];

    [self requestData];
    [MBProgressHUD showMessage:@"message"];

    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
    
    [self requestData];
    [MBProgressHUD showMessage:@"message"];
}
- (void)requestData
{
    [[HHRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{} requestType:POST
       success:^(id  _Nonnull responseObject) {
           [MBProgressHUD showMessage:@"请求成功"];

       } failure:^(RequestErrorType error) {
           [MBProgressHUD showMessage:@"请求失败"];

       } isSupportHud:YES isSupportErrorAlert:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
  
     [[HHRequestManager defaultManager]requestByUrl:@"http://58.215.175.244:8090/thirdprovider/datacenter/area/findAllAreaJsonTree" params:@{@"userId":@"8"} requestType:POST
       success:^(id  _Nonnull responseObject) {
           [MBProgressHUD showMessage:@"请求成功"];
           
//         [self.navigationController popViewControllerAnimated:YES];
//
//         if (_backBlock) {
//             _backBlock();
//         }

       } failure:^(RequestErrorType error) {
           [MBProgressHUD showMessage:@"请求失败"];
           

       } isSupportHud:NO isSupportErrorAlert:YES];
    
  
 
    
}

- (void)downloadFile
{
    //下载
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/QQ_V6.5.3.dmg"];
    [[HHRequestManager defaultManager]download:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V6.5.3.dmg" downloadPath:path progress:^(NSProgress * _Nonnull progress) {

        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat percent = progress.completedUnitCount/(CGFloat)progress.totalUnitCount;
            [SVProgressHUD showProgress:percent status:@"下载进度"];
        });


    } success:^(NSString * _Nonnull filePath) {
        NSLog(@"download complate");
        [SVProgressHUD dismiss];
    } failure:^(RequestErrorType error) {

    } isSupportHud:NO isSupportErrorAlert:YES];
}
- (void)uploadFile
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"video.mov" withExtension:nil];
    
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
