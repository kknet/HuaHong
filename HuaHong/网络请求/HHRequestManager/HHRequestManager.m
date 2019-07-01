//
//  HHRequestManager.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/1.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HHRequestManager.h"
#import "HHHttpSessionManager.h"
#import "HHRequestManager+Extension.h"

@interface HHRequestManager ()
@property(nonatomic, strong) HHHttpSessionManager *sessionManager;
@end

@implementation HHRequestManager

+ (instancetype)defaultManager
{
    static HHRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HHRequestManager alloc]init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [[HHHttpSessionManager alloc]init];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.timeoutInterval = 20;
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

#pragma mark -设置baseurl
- (void)setBaseUrl:(NSString *)baseUrl
{
    _sessionManager.baseUrl = baseUrl;
}

#pragma mark -设置requestSerializer
- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer
{
    _sessionManager.requestSerializer = requestSerializer;
}

#pragma mark -监听网络变化
- (void)setReachablityUrl:(NSString *)baseUrl
{
    self.baseUrl = baseUrl;
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netType = status;
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark -设置请求头部信息
- (void)setRequestHeaderField:(NSDictionary *)params
{
    
    [params.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_sessionManager.requestSerializer setValue:params[obj] forHTTPHeaderField:obj];
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
        [_sessionManager setSecurityPolicy:[self customSecurityPolicy:SSLCertPath]];
    }else
    {
        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [_sessionManager.securityPolicy setAllowInvalidCertificates:YES];
        [_sessionManager.securityPolicy setValidatesDomainName:NO];
    }
}

#pragma mark -判断是否设置代理
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

#pragma mark -发起请求
- (NSURLSessionTask *)requestDataByUrl:(NSString * _Nonnull (^)(void))urlBlock withParams:(id  _Nonnull (^)(void))paramsBlock withHttpType:(HHRequestType (^)(void))httpTypeBlock withProgress:(void (^)(id _Nonnull))progressBlock withResultBlock:(void (^)(id _Nonnull))resultBlock withErrorBlock:(void (^)(HHRequestErrorType))errorBlock isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert{
    
    if (![self getProxyStatus]) {
        return nil;
    }
    
    
    NSURLSessionTask *sessionTask;
    NSString *url = urlBlock();
    NSDictionary *params = paramsBlock();
    HHRequestType requestType = httpTypeBlock();
    
   NSLog(@"httpRequest:%@%@\nparams:%@",_sessionManager.baseURL.absoluteString,url,params);
    
    switch (requestType) {
        case HHRequestGET:
        {
            if (isSupportHud) {
                [self startLoading];
            }
            
            sessionTask = [_sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progressBlock) {
                    progressBlock(downloadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            break;
        case HHRequestPOST:
        {
            if (isSupportHud) {
              [self startLoading];
            }
            
            sessionTask = [_sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            
            break;
        case HHRequestFORM:
        {
            if (isSupportHud) {
                [self startLoading];
            }
            
            sessionTask = [_sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (self.postfiles) {
                    NSArray *images = self.postfiles[@"images"];
                    NSArray *imagekeys = self.postfiles[@"imagekeys"];
                    NSArray *filekeys = self.postfiles[@"filekeys"];
                    
                    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [formData appendPartWithFileData:UIImagePNGRepresentation(obj) name:filekeys[idx] fileName:imagekeys[idx] mimeType:@"image/jpg"];
                    }];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    progressBlock(uploadProgress);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
            
            break;
        case HHRequestUPLOAD:
        {
            if (isSupportHud) {
                [self startLoading];
            }
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionUploadTask *task = [_sessionManager uploadTaskWithRequest:request fromData:self.uploadFileData progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progressBlock) {
                    progressBlock(uploadProgress);
                }
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
            }];
            
            [task resume];
            sessionTask = task;
        }
            
            break;
        case HHRequestDOWNLOAD:
        {
            if (isSupportHud) {
                [self startLoading];
            }
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSURLSessionDownloadTask *task = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progressBlock) {
                    progressBlock(downloadProgress);
                }
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:self.downloadPath];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                
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

- (void)uploadFile:(NSString *)url params:(id)params fileDatas:(NSArray<NSData *> *)fileDatas fileName:(NSString *)fileName fileType:(NSString *)fileType progress:(void (^)(id _Nonnull))progress result:(void (^)(id _Nonnull))result error:(void (^)(HHRequestErrorType))errorBlock isSupportHud:(BOOL)isSupportHud
{
    if (isSupportHud) {
        [self startLoading];
    }
    
    [_sessionManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [fileDatas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj name:[NSString stringWithFormat:@"%ld%@",idx,fileName] fileName:[NSString stringWithFormat:@"%ld%@",idx,fileName] mimeType:fileType];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
