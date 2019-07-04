//
//  QKRequestManager.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/4.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "QKRequestManager.h"

@implementation QKRequestManager

+ (instancetype)defaultManager
{
    static QKRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QKRequestManager alloc]init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[QKHTTPSessionManager alloc]init];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 20;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    
    return self;
}

#pragma mark -设置baseurl
- (void)setBaseUrl:(NSString *)baseUrl
{
    _manager.baseUrl = baseUrl;
}

#pragma mark -设置requestSerializer
- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
{
    _manager.requestSerializer = requestSerializer;
}

#pragma mark -监听网络变化
- (void)startNetMonitoring
{
    //    self.baseUrl = @"https://www.baidu.com";
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netType = status;
    }];
    
    
}

#pragma mark -设置请求头部信息
- (void)setRequestHeaderField:(NSDictionary *)params
{
    
    [params.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:params[obj] forHTTPHeaderField:obj];
    }];
}

#pragma mark -SSL证书引用

- (AFSecurityPolicy *)customSecurityPolicy:(NSString *)cerPath
{
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    policy.allowInvalidCertificates = YES;
    
    policy.validatesDomainName = NO;
    
    policy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return policy;
}
- (void)setSSLCertPath:(NSString *)SSLCertPath
{
    if (SSLCertPath) {
        [_manager setSecurityPolicy:[self customSecurityPolicy:SSLCertPath]];
    }else
    {
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_manager.securityPolicy setAllowInvalidCertificates:YES];
        [_manager.securityPolicy setValidatesDomainName:NO];
    }
}

#pragma mark -判断是否设置代理
- (BOOL)getProxyStatus {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com&quot"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //        NSLog(@"没代理");
        return YES;
    }
    else
    {
        NSLog(@"设置了代理");
        return NO;
    }
}

#pragma mark -发起请求
/**
 发起网络请求
 
 @param url url地址
 @param params 参数
 @param requestType 请求类型
 @param progressBlock 进度回调
 @param successBlock 结果回调
 @param errorBlock 错误回调
 @param isSupportHud 是否有加载框
 @param isSupportErrorAlert 是否有错误提示
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestByUrl:(NSString *)url
                            params:(id _Nullable)params
                       requestType:(QKRequestType)requestType
                          progress:(void  (^ _Nullable)(NSProgress *progress))progressBlock
                           success:(void (^)(id responseObject))successBlock
                           failure:(void (^)(QKRequestErrorType error))errorBlock
                      isSupportHud:(BOOL)isSupportHud
               isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [SVProgressHUD showInfoWithStatus:@"请关闭网络代理"];
        return nil;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        errorBlock(QKRequestErrorNone);
        
        if (isSupportErrorAlert) {
            [SVProgressHUD showInfoWithStatus:@"亲，您的手机貌似没联网"];
        }
        
        return nil;
    }
    
    NSURLSessionTask *sessionTask;
    
    NSLog(@"httpRequest:%@%@\nparams:%@",_manager.baseURL.absoluteString,url,params);
    
    if (isSupportHud) {
        [SVProgressHUD showWithStatus:@"加载中..."];
    }
    
    switch (requestType) {
        case QKRequestGET:
        {
            sessionTask = [_manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(downloadProgress);
                    }
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jsonParse:responseObject url:url withResultBlock:successBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                });
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                });
                
            }];
        }
            break;
        case QKRequestPOST:
        {
            
            sessionTask = [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(uploadProgress);
                    }
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self jsonParse:responseObject url:url withResultBlock:successBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                });
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                });
            }];
        }
            
            break;
        default:
            break;
    }
    
    
    return sessionTask;
}



/**
 上传文件
 
 @param url url地址
 @param params 参数
 @param fileDatas 二进制文件数组
 @param fileName 文件名
 @param fileType 文件类型
 @param progress 进度回调
 @param result 结果回调
 @param errorBlock 错误回调
 @param isSupportHud 是否有加载框
 */
- (void)uploadFile:(NSString *)url
            params:(id)params
         fileDatas:(NSArray <NSData *>*)fileDatas
          fileName:(NSString *)fileName
          fileType:(NSString *)fileType
          progress:(void (^ _Nullable)(NSProgress *progress))progress
            result:(void (^)(id data))result
             error:(void (^)(QKRequestErrorType errorType))errorBlock
      isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [SVProgressHUD showInfoWithStatus:@"请关闭网络代理"];
        return;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        errorBlock(QKRequestErrorNone);
        
        if (isSupportErrorAlert) {
            [SVProgressHUD showInfoWithStatus:@"亲，您的手机貌似没联网"];
        }
        
        return;
    }
    NSLog(@"httpRequest:%@%@\nfileDatas:%@",_manager.baseURL.absoluteString,url,fileDatas);
    
    if (isSupportHud) {
        [SVProgressHUD showWithStatus:@"上传中..."];
        
    }
    
    [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [fileDatas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:[NSString stringWithFormat:@"%lu%@",(unsigned long)idx,fileName] fileName:[NSString stringWithFormat:@"%lu%@",(unsigned long)idx,fileName] mimeType:fileType];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(uploadProgress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self jsonParse:responseObject url:url withResultBlock:responseObject withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
        });
        
    }];
}


/**
 下载文件
 
 @param url url地址
 @param downloadPath 参数
 @param progressBlock 进度回调
 @param successBlock 结果回调
 @param errorBlock 错误回调
 @param isSupportHud 是否有加载框
 @param isSupportErrorAlert 是否有错误提示
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)download:(NSString *)url
                  downloadPath:(NSString *)downloadPath
                      progress:(void (^ _Nullable)(NSProgress *progress))progressBlock
                       success:(void (^)(NSString *filePath))successBlock
                       failure:(void (^)(QKRequestErrorType error))errorBlock
                  isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [SVProgressHUD showInfoWithStatus:@"请关闭网络代理"];
        return nil;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        errorBlock(QKRequestErrorNone);
        
        if (isSupportErrorAlert) {
            [SVProgressHUD showInfoWithStatus:@"亲，您的手机貌似没联网"];
        }
        
        return nil;
    }
    NSLog(@"httpRequest:%@%@\ndownloadPath:%@",_manager.baseURL.absoluteString,url,downloadPath);
    
    if (isSupportHud) {
        [SVProgressHUD showWithStatus:@"正在下载..."];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //         CGFloat percent = uploadProgress.completedUnitCount/(CGFloat)uploadProgress.totalUnitCount;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress);
            }
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:downloadPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                if (isSupportHud) {
                    [SVProgressHUD dismiss];
                }
                
                if (successBlock) {
                    successBlock(filePath.path);
                }
            }else
            {
                [self parseError:error url:url withTask:response withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
            }
        });
        
    }];
    
    [task resume];
    return task;
}


#pragma mark -处理请求结果
- (void)jsonParse:(NSData *)data
              url:(NSString *)url
  withResultBlock:(void (^)(id data))resultBlock
   withErrorBlock:(void (^)(QKRequestErrorType errorType))errorBlock
     isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert {
    
    
    if (isSupportHud) {
        [SVProgressHUD dismiss];
    }
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"url:%@",url);
    NSLog(@"result:%@",result);
    
    if (error) {
        if (errorBlock) {
            errorBlock(QKRequestErrorJsonParseFail);
        }
        if (isSupportErrorAlert) {
            [SVProgressHUD showInfoWithStatus:@"解析错误"];
        }
        
        return;
    }
    
    
    if (self.filterResponseCallback) {
        void(^continueBlock)(id result) = ^(id result) {
            if (resultBlock) {
                resultBlock(result);
            }
        };
        self.filterResponseCallback(result, continueBlock);
    } else {
        if (resultBlock) {
            resultBlock(result);
        }
    }
    
    
    
}

#pragma mark -处理错误
- (void)parseError:(NSError *)error url:(NSString *)url withTask:(id)task withErrorBlock:(void (^)(QKRequestErrorType errorType))errorBlock isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    
    if (isSupportHud) {
        [SVProgressHUD dismiss];
    }
    
    NSHTTPURLResponse *response;
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        response = (NSHTTPURLResponse *)((NSURLSessionDataTask *)task).response;
    }else if ([task isKindOfClass:[NSURLResponse class]]){
        response = (NSHTTPURLResponse *)task;
    }
    
    if (response.statusCode == 404) {
        if (errorBlock) {
            errorBlock(QKRequestErrorNet404);
        }
    }else if (response.statusCode == 500){
        if (errorBlock) {
            errorBlock(QKRequestErrorNet500);
        }
    }else
    {
        if (errorBlock) {
            errorBlock(QKRequestErrorNetOther);
        }
    }
    
    
    NSLog(@"url:%@",url);
    NSLog(@"response:%@",response);
    NSLog(@"error:%@",error.description);
    
    if (isSupportErrorAlert) {
        [SVProgressHUD showInfoWithStatus:@"网络请求错误"];
    }
}
@end
