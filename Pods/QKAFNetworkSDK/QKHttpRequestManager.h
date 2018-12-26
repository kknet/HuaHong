//
//  HttpRequestManager.h
//  QKPublic
//
//  Created by qk365 on 2017/9/7.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum : NSUInteger {
    QKPublicGET,
    QKPublicPOST,
    QKPublicFORM,
    QKPublicUPLOAD,
    QKPublicDOWNLOAD
} QKPublicHttpType;

typedef enum : NSUInteger {
    QKPublicUnknown,
    QKPublicNotReachable,
    QKPublicWWAN,
    QKPublicWiFi,
} QKPublicNetType;

typedef NS_ENUM(NSInteger, QKPublicHttpRequestErrorType) {
    /**
     * 无网络.
     */
    QKPublicHttpRequestErrorTypeNone,
    /**
     * 解析失败.
     */
    QKPublicHttpRequestErrorTypeJsonParseFail,
    /**
     * 网络错误.
     */
    QKPublicHttpRequestErrorTypeNet404,
    QKPublicHttpRequestErrorTypeNet500,
    QKPublicHttpRequestErrorTypeNetOther,
};

@interface QKHttpRequestManager : NSObject

/**
 The URL used to construct requests from relative paths in methods like `requestWithMethod:URLString:parameters:`, and the `GET` / `POST` / et al. convenience methods.
 */
@property (nonatomic, strong) NSString *baseUrl;

/**
 当前网络状态
 */
@property (nonatomic, assign) QKPublicNetType netType;

/**
 SSL证书路径
 */
@property (nonatomic, strong) NSString *SSLCertPath;

/**
 form提交的文件集合
 ex: @{@"images":[],
 @"imagekeys":[],
 @"fileKeys":[]
 }
 */
@property (nonatomic, strong) NSDictionary *postfiles;

/**
 上传的文件
 */
@property (nonatomic, strong) NSData *uploadFileData;

/**
 下载的目标路径
 */
@property (nonatomic, strong) NSString *downloadPath;

/**
 加载的gif图
 */
@property (nonatomic, strong) NSString *loadingGifName;

/**
 requestSerializer
 */
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

/*
 * 错误提示
 {
 @"errorCode":[@(401),@(1001)],
 @"retryImage":@"本地图片",
 @"noNetImage":@"本地图片",
 @"retryTxt":@"重新加载",
 @"noNetTxt":@"木有网络"
 }
 */
@property (nonatomic, strong) NSDictionary *errorParams;

/*
 * 结果预处理回调
 */
@property (nonatomic, strong) void(^filterResponseDataCallback)(id data, void(^continueResponseBlock)(id result));

/*
 * 接口调用无网络回调
 */
@property (nonatomic, strong) void(^notNetRequestCallback)(id params,void(^continueRequestBlock)(id params));

/**
 singleton
 */
+ (instancetype)defaultManager;

/**
 初始化监听baseUrl
 */
- (void)setReachabilityUrl:(NSString *)baseUrl;

/**
 设置requestHeader
 */
- (void)setRequestHeaderField:(NSDictionary *)params;

/**
 请求发起
 */
- (NSURLSessionTask *)requestDataByUrl:(NSString * (^)(void))urlBlock
                            withParams:(id (^)(void))paramsBlock
                          withHttpType:(QKPublicHttpType (^)(void))httpTypeBlock
                          withProgress:(void (^)(id progress))progressBlock
                       withResultBlock:(void (^)(id data))resultBlock
                        withErrorBlock:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
                          isSupportHud:(BOOL)isSupportHud
                   isSupportErrorAlert:(BOOL)isSupportErrorAlert;

/** 判断是否设置代理 */
- (BOOL)getProxyStatus;

/**
 上传文件
 
 @param url 地址
 @param params params
 @param fileDatas 文件二进制集合
 @param fileName 文件名
 @param fileType 文件类型
 @param progress 进度回调
 @param result 结果
 @param errorBlock 错误信息
 @param isSupportHud hud
 */
- (void)uploadFile:(NSString * )url
            params:(id)params
         fileDatas:(NSArray<NSData *> *)fileDatas
          fileName:(NSString *)fileName
          fileType:(NSString *)fileType
          progress:(void (^)(id progress))progress
            result:(void (^)(id data))result
             error:(void (^)(QKPublicHttpRequestErrorType errorType))errorBlock
      isSupportHud:(BOOL)isSupportHud;


@end

