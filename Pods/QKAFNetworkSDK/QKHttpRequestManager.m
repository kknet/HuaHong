//
//  HttpRequestManager.m
//  QKPublic
//
//  Created by qk365 on 2017/9/7.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import "QKHttpRequestManager.h"
#import "QKHTTPSessionManager.h"
#import "SBJson4.h"
#import "QKHttpRequestManager+UIExtend.h"
#import "QKProgressHUD.h"
#import <CFNetwork/CFNetwork.h>

@interface QKHttpRequestManager()
{
    QKHTTPSessionManager *_manager;
}

@end

@implementation QKHttpRequestManager

#pragma mark -实例化

+ (instancetype)defaultManager {
    static QKHttpRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [QKHttpRequestManager new];
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [[QKHTTPSessionManager alloc] init];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

#pragma mark -设置baseurl
- (void)setBaseUrl:(NSString *)baseUrl {
    _manager.baseUrl = baseUrl;
}

#pragma mark -设置requestSerializer
- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
{
    _manager.requestSerializer = requestSerializer;
}

#pragma mark -监听网络变化
- (void)setReachabilityUrl:(NSString *)baseUrl {
    
    self.baseUrl = baseUrl;
    //网络监听
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self reachabilityChanged:status];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)reachabilityChanged:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            break;
        case AFNetworkReachabilityStatusNotReachable:
            self.netType = QKPublicNotReachable;
            NSLog(@"没有网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            self.netType = QKPublicWWAN;
            NSLog(@"正在使用3G网络");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.netType = QKPublicWiFi;
            NSLog(@"正在使用wifi网络");
            break;
            
        default:
            break;
    }
}

#pragma mark -设置请求头部信息
- (void)setRequestHeaderField:(NSDictionary *)params {
    
    [params.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:params[obj] forHTTPHeaderField:obj];
    }];
}

#pragma mark -SSL证书引用
- (void)setSSLCertPath:(NSString *)SSLCertPath {
    
    if (SSLCertPath) {
        [_manager setSecurityPolicy:[self customSecurityPolicy:SSLCertPath]];
    } else {
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_manager.securityPolicy setAllowInvalidCertificates:YES];
        [_manager.securityPolicy setValidatesDomainName:NO];
    }
}

- (AFSecurityPolicy*)customSecurityPolicy:(NSString *)cerPath
{
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithArray:@[certData]];
    
    return securityPolicy;
}

#pragma mark -发起请求
- (NSURLSessionTask *)requestDataByUrl:(NSString * (^)(void))urlBlock
                            withParams:(id (^)(void))paramsBlock
                          withHttpType:(QKPublicHttpType (^)(void))httpTypeBlock
                          withProgress:(void (^)(id progress))progressBlock
                       withResultBlock:(void (^)(id data))resultBlock
                        withErrorBlock:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
                          isSupportHud:(BOOL)isSupportHud
                   isSupportErrorAlert:(BOOL)isSupportErrorAlert {
    
    if (![self getProxyStatus]) {
        return nil;
    }
    
    NSDictionary *requestInfo;
    if (self.loadingGifName) {
        requestInfo = @{@"urlBlock":urlBlock,
                        @"paramsBlock":paramsBlock,
                        @"httpTypeBlock":httpTypeBlock,
                        @"progressBlock":progressBlock,
                        @"resultBlock":resultBlock,
                        @"errorBlock":errorBlock,
                        @"isSupportHud":@(isSupportHud),
                        @"isSupportErrorAlert":@(isSupportErrorAlert)
                        };
    }
    
    if (_netType == QKPublicNotReachable) {
        if (self.loadingGifName && self.errorParams && isSupportHud) {
            if (self.notNetRequestCallback) {
                void (^continueRequestBlock)(id params) = ^(id params) {
                    [QKProgressHUD transferShowError:self.errorParams[@"noNetImage"] noticeTxt:self.errorParams[@"noNetTxt"] requestInfo:requestInfo clickEventCallback:^(NSInteger index, QKProgressHUD *hud) {
                        NSDictionary *requestInfo = hud.requestInfo;
                        [self requestDataByUrl:requestInfo[@"urlBlock"] withParams:requestInfo[@"paramsBlock"] withHttpType:requestInfo[@"httpTypeBlock"] withProgress:requestInfo[@"progressBlock"] withResultBlock:requestInfo[@"resultBlock"] withErrorBlock:requestInfo[@"errorBlock"] isSupportHud:[requestInfo[@"isSupportHud"] boolValue] isSupportErrorAlert:[requestInfo[@"isSupportErrorAlert"] boolValue]];
                    }];
                };
                self.notNetRequestCallback(requestInfo, continueRequestBlock);
            }
        } else {
            if (self.notNetRequestCallback) {
                void (^continueRequestBlock)(id params) = ^(id params) {
                    if (isSupportHud) {
                        [self netLoading];
                    }
                    errorBlock(QKPublicHttpRequestErrorTypeNone);
                };
                self.notNetRequestCallback(requestInfo, continueRequestBlock);
            }
        }
        return nil;
    }
    NSURLSessionTask *sessionTask;
    NSString *url = urlBlock();
    NSDictionary *params = paramsBlock();
    QKPublicHttpType httpType = httpTypeBlock();
    
    NSLog(@">>> url:%@%@\nparams:%@",_manager.baseURL.absoluteString,url,params);
    
    switch (httpType) {
        case QKPublicGET:
        {
            if (isSupportHud) {
                if (self.loadingGifName) {
                    [QKProgressHUD showWithGif:self.loadingGifName requestInfo:requestInfo];
                } else {
                    [self startLoading];
                }
            }
            sessionTask = [_manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progressBlock) {
                    progressBlock(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self jsonParse:responseObject url:url withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            }];
        }
            break;
            
        case QKPublicPOST:
        {
            if (isSupportHud) {
                if (self.loadingGifName) {
                    [QKProgressHUD showWithGif:self.loadingGifName requestInfo:requestInfo];
                } else {
                    [self startLoading];
                }
            }
            sessionTask = [_manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self jsonParse:responseObject url:url withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            }];
        }
            break;
            
        case QKPublicFORM:
        {
            if (isSupportHud) {
                [self startLoading];
            }
            sessionTask = [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                if (self.postfiles) {
                    NSArray *images = self.postfiles[@"images"];
                    NSArray *imagekeys = self.postfiles[@"imagekeys"];
                    NSArray *fileKeys = self.postfiles[@"fileKeys"];
                    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [formData appendPartWithFileData:UIImagePNGRepresentation(obj) name:fileKeys[idx] fileName:imagekeys[idx] mimeType:@"image/jpg"];
                    }];
                }
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self jsonParse:responseObject url:url withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                
            }];
        }
            break;
            
        case QKPublicUPLOAD:
        {
            ProgressCallback progressCallback;
            if (isSupportHud) {
                progressCallback = [self startFileLoading];
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionUploadTask *task = [_manager uploadTaskWithRequest:request fromData:self.uploadFileData progress:^(NSProgress * _Nonnull uploadProgress) {
                
                if (isSupportHud) {
                    CGFloat percent = uploadProgress.completedUnitCount/(CGFloat)uploadProgress.totalUnitCount;
                    if (progressCallback) {
                        progressCallback(percent);
                    };
                }
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    
                    [self jsonParse:responseObject  url:url withResultBlock:resultBlock withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                    
                } else {
                    
                    [self parseError:error  url:url withTask:response withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                    
                }
            }];
            [task resume];
            sessionTask = task;
        }
            break;
            
        case QKPublicDOWNLOAD:
        {
            ProgressCallback progressCallback;
            if (isSupportHud) {
                progressCallback = [self startFileLoading];
            }
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionDownloadTask *task = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                
                if (isSupportHud) {
                    CGFloat percent = downloadProgress.completedUnitCount/(CGFloat)downloadProgress.totalUnitCount;
                    if (progressCallback) {
                        progressCallback(percent);
                    };
                }
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                
                return [NSURL fileURLWithPath:self.downloadPath];
                
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                NSLog(@"<<< download filepath:%@\nerror:%@",filePath,error);
                
                if (!error) {
                    
                    if (isSupportHud) {
                        [self stopLoading];
                    }
                    if (resultBlock) {
                        resultBlock(filePath.path);
                    }
                    
                } else {
                    [self parseError:error url:url withTask:response withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
                }
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

/** 判断是否设置代理 */
- (BOOL)getProxyStatus {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com&quot"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSLog(@"\n%@",proxies);
    
    NSDictionary *settings = proxies[0];
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        NSLog(@"没代理");
        return YES;
    }
    else
    {
        NSLog(@"设置了代理");
        return NO;
    }
}

-(void)uploadFile:(NSString *)url params:(id)params fileDatas:(NSArray<NSData *> *)fileDatas fileName:(NSString *)fileName fileType:(NSString *)fileType progress:(void (^)(id))progress result:(void (^)(id))result error:(void (^)(QKPublicHttpRequestErrorType))errorBlock isSupportHud:(BOOL)isSupportHud
{
    if (isSupportHud) {
        [self startLoading];
    }
    [_manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [fileDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:[NSString stringWithFormat:@"%ld%@",idx, fileName] fileName:[NSString stringWithFormat:@"%ld%@",idx, fileName] mimeType:fileType];
        }];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self jsonParse:responseObject url:url withResultBlock:result withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self parseError:error url:url withTask:task withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:NO];
        
    }];
}

#pragma mark -处理请求结果
- (void)jsonParse:(NSData *)data
              url:(NSString *)url
  withResultBlock:(void (^)(id data))resultBlock
   withErrorBlock:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
     isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert {
    
    if (isSupportHud) {
        if (self.loadingGifName) {
            [QKProgressHUD dismiss];
        } else {
            [self stopLoading];
        }
    }
    
    SBJson4Parser *parse = [SBJson4Parser parserWithBlock:^(id item, BOOL *stop) {
        
        NSLog(@"<<< url:%@",url);
        NSLog(@"<<< result:%@",item);
        
        if (self.filterResponseDataCallback) {
            void(^continueBlock)(id result) = ^(id result) {
                if (resultBlock) {
                    resultBlock(result);
                }
            };
            self.filterResponseDataCallback(item, continueBlock);
        } else {
            if (resultBlock) {
                resultBlock(item);
            }
        }
        
    } allowMultiRoot:YES unwrapRootArray:YES errorHandler:^(NSError *error) {
        
        if (errorBlock) {
            errorBlock(QKPublicHttpRequestErrorTypeJsonParseFail);
        }
        if (isSupportErrorAlert) {
            [self showErrorMsg:@"解析失败!"];
        }
        
    }];
    [parse parse:data];
}

#pragma mark -处理错误
- (void)parseError:(NSError *)error
               url:(NSString *)url
          withTask:(id)task
    withErrorBlock:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
      isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert {
    
    if (isSupportHud) {
        if (!self.loadingGifName) {
            [self stopLoading];
        }
    }
    NSLog(@"<<< url:%@",url);
    
    NSHTTPURLResponse *response = nil;
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        response = (NSHTTPURLResponse *)((NSURLSessionDataTask *)task).response;
    } else if ([task isKindOfClass:[NSURLResponse class]]) {
        response = (NSHTTPURLResponse *)task;
    }
    NSString *errorMsg = @"网络异常，请重新尝试！";
    if (response) {
        if (self.errorParams) {
            NSArray *errorCodes = self.errorParams[@"errorCode"];
            if ([errorCodes containsObject:@(response.statusCode)]) {
                [self handleError:errorMsg withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
            }
        } else {
            if (response.statusCode == 404) {
                if (errorBlock) {
                    errorBlock(QKPublicHttpRequestErrorTypeNet404);
                }
            } else if (response.statusCode == 500) {
                if (errorBlock) {
                    errorBlock(QKPublicHttpRequestErrorTypeNet500);
                }
            } else {
                if (errorBlock) {
                    errorBlock(QKPublicHttpRequestErrorTypeNetOther);
                }
            }
        }
    } else {
        [self handleError:errorMsg withErrorBlock:errorBlock isSupportHud:isSupportHud isSupportErrorAlert:isSupportErrorAlert];
    }
    
    NSLog(@"error.description = %@",error.description);
}

- (void)handleError:(NSString *)errorMsg
     withErrorBlock:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
       isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    if (self.loadingGifName && isSupportHud) {
        [QKProgressHUD transferShowError:self.errorParams[@"retryImage"] noticeTxt:self.errorParams[@"retryTxt"] requestInfo:nil clickEventCallback:^(NSInteger index, QKProgressHUD *hud) {
            NSDictionary *requestInfo = hud.requestInfo;
            [self requestDataByUrl:requestInfo[@"urlBlock"] withParams:requestInfo[@"paramsBlock"] withHttpType:requestInfo[@"httpTypeBlock"] withProgress:requestInfo[@"progressBlock"] withResultBlock:requestInfo[@"resultBlock"] withErrorBlock:requestInfo[@"errorBlock"] isSupportHud:[requestInfo[@"isSupportHud"] boolValue] isSupportErrorAlert:[requestInfo[@"isSupportErrorAlert"] boolValue]];
        }];
    } else {
        if (isSupportErrorAlert) {
            [self showErrorMsg:errorMsg];
        }
    }
    if (errorBlock) {
        errorBlock(QKPublicHttpRequestErrorTypeNetOther);
    }

}

@end

