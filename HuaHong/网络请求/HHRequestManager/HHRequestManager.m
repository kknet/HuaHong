//
//  HHRequestManager.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/1.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HHRequestManager.h"

@implementation HHRequestManager

+ (instancetype)defaultManager
{
    static HHRequestManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HHRequestManager alloc]init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [[HHHttpSessionManager alloc]init];
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
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    policy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
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
//    NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
//    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
//    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
//    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
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
                            params:(id)params
                       requestType:(RequestType)requestType
                          progress:(void (^ _Nullable)(NSProgress *progress))progressBlock
                           success:(void (^)(id responseObject))successBlock
                           failure:(void (^)(RequestErrorType error))errorBlock
                      isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [MBProgressHUD showInfo:@"请关闭网络代理" toView:nil];
        return nil;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        //目前没啥用
        if (self.noNetRequestCallback) {
            void(^continueRequestBlock)(id params) = ^(id params){
           
            };
            
            self.noNetRequestCallback(params, continueRequestBlock);
        }


        errorBlock(RequestErrorNone);

        if (isSupportErrorAlert) {
          [MBProgressHUD showInfo:@"亲，您的手机貌似没联网" toView:nil];
        }
        
        
        return nil;
    }
    
    NSURLSessionTask *sessionTask;
    
   NSLog(@"httpRequest:%@%@\nparams:%@",_manager.baseURL.absoluteString,url,params);
    
    if (isSupportHud) {
        [MBProgressHUD showLoading:@"加载中..." toView:nil];
    }
    
    switch (requestType) {
        case GET:
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
        case POST:
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
        case UPLOAD:
        {
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionUploadTask *task = [_manager uploadTaskWithRequest:request fromData:self.uploadFileData progress:^(NSProgress * _Nonnull uploadProgress) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressBlock) {
                        progressBlock(uploadProgress);
                    }
                });
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        [self jsonParse:responseObject url:url withResultBlock:successBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                    }else
                    {
                        [self parseError:error url:url withTask:response withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                    }
                });
                
            }];
            
            [task resume];
            sessionTask = task;
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
             error:(void (^)(RequestErrorType errorType))errorBlock
      isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [MBProgressHUD showInfo:@"请关闭网络代理" toView:nil];
        return;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        errorBlock(RequestErrorNone);
        
        if (isSupportErrorAlert) {
            [MBProgressHUD showInfo:@"亲，您的手机貌似没联网" toView:nil];
        }
        
        return;
    }
    NSLog(@"httpRequest:%@%@\nfileDatas:%@",_manager.baseURL.absoluteString,url,fileDatas);
    
    if (isSupportHud) {
        [MBProgressHUD showLoading:@"上传中..." toView:nil];
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
                       failure:(void (^)(RequestErrorType error))errorBlock
                  isSupportHud:(BOOL)isSupportHud
           isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        
        [MBProgressHUD showInfo:@"请关闭网络代理" toView:nil];
        return nil;
    }
    
    if (_netType == AFNetworkReachabilityStatusNotReachable) {
        
        errorBlock(RequestErrorNone);
        
        if (isSupportErrorAlert) {
            [MBProgressHUD showInfo:@"亲，您的手机貌似没联网" toView:nil];
        }
        
        return nil;
    }
    NSLog(@"httpRequest:%@%@\ndownloadPath:%@",_manager.baseURL.absoluteString,url,downloadPath);
    
    if (isSupportHud) {
        [MBProgressHUD showLoading:@"正在下载..." toView:nil];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *task = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //         CGFloat percent = uploadProgress.completedUnitCount/(CGFloat)uploadProgress.totalUnitCount;
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
                    [MBProgressHUD hideHUDForView:nil];
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
   withErrorBlock:(void (^)(RequestErrorType errorType))errorBlock
     isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert {
    
    
    if (isSupportHud) {
        [MBProgressHUD hideHUDForView:nil];
    }
    
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSLog(@"url:%@",url);
    NSLog(@"result:%@",result);
    
    if (error) {
        if (errorBlock) {
            errorBlock(RequestErrorJsonParseFail);
        }
        if (isSupportErrorAlert) {
            [MBProgressHUD showInfo:@"解析错误" toView:nil];
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
- (void)parseError:(NSError *)error url:(NSString *)url withTask:(id)task withErrorBlock:(void (^)(RequestErrorType errorType))errorBlock isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    
    if (isSupportHud) {
        [MBProgressHUD hideHUDForView:nil];
    }
    
    NSHTTPURLResponse *response;
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        response = (NSHTTPURLResponse *)((NSURLSessionDataTask *)task).response;
    }else if ([task isKindOfClass:[NSURLResponse class]]){
        response = (NSHTTPURLResponse *)task;
    }
    
    if (response.statusCode == 404) {
        if (errorBlock) {
            errorBlock(RequestErrorNet404);
        }
    }else if (response.statusCode == 500){
        if (errorBlock) {
            errorBlock(RequestErrorNet500);
        }
    }else
    {
        if (errorBlock) {
            errorBlock(RequestErrorNetOther);
        }
    }
    
    
    NSLog(@"url:%@",url);
    NSLog(@"response:%@",response);
    NSLog(@"error:%@",error.description);
    
    if (isSupportErrorAlert) {
        [MBProgressHUD showInfo:@"网络请求错误" toView:nil];
    }
}
@end
