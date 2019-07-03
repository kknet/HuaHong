//
//  HHRequestManager.h
//  HuaHong
//
//  Created by qk-huahong on 2019/7/1.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHRequestType) {
    HHRequestGET,
    HHRequestPOST,
    HHRequestFORM,
    HHRequestUPLOAD,
    HHRequestDOWNLOAD
};

typedef NS_ENUM(NSUInteger, HHRequestErrorType) {
    /**
     * 无网络.
     */
    HHRequestErrorNone,
    /**
     * 解析失败.
     */
    HHRequestErrorJsonParseFail,
    /**
     * 网络错误.
     */
    HHRequestErrorNet404,
    HHRequestErrorNet500,
    HHRequestErrorNetOther
};

@interface HHRequestManager : NSObject

+ (instancetype)defaultManager;

@property(nonatomic, copy) NSString *baseUrl;

//当前网络状态
@property(nonatomic, assign) AFNetworkReachabilityStatus netType;

//SSL证书路径
@property(nonatomic, copy) NSString *SSLCertPath;

/**
 form提交的文件集合
 ex: @{@"images":[],
 @"imagekeys":[],
 @"filekeys":[]
 }
 */
@property(nonatomic,strong) NSDictionary *postfiles;

//上传的文件
@property(nonatomic, strong) NSData *uploadFileData;

//下载的路径
@property(nonatomic, copy) NSString *downloadPath;

//加载的GIF
@property(nonatomic, copy) NSString *gifName;

@property(nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

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
@property(nonatomic,strong) NSDictionary *errorParams;

//结果处理回调
@property(nonatomic, strong) void(^filterResponseCallback)(id data,void(^continueResponseBlock)(id result));

//接口调用无网络回调
@property(nonatomic, strong) void(^noNetRequestCallback)(id params,void(^continueResponseBlock)(id params));

//初始化监听baseURL
- (void)setReachablityUrl:(NSString *)baseUrl;

//设置requestHeader
- (void)setRequestHeaderField:(NSDictionary *)params;

//判断是否设置代理
- (BOOL)getProxyStatus;


/**
 发起网络请求

 @param urlBlock url地址
 @param paramsBlock 参数
 @param httpTypeBlock 请求类型
 @param progressBlock 进度回调
 @param resultBlock 结果回调
 @param errorBlock 错误回调
 @param isSupportHud 是否有加载框
 @param isSupportErrorAlert 是否有错误提示
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestDataByUrl:(NSString *(^)(void))urlBlock
                            withParams:(id (^)(void))paramsBlock
                          withHttpType:(HHRequestType (^)(void))httpTypeBlock
                          withProgress:(void (^)(id progress))progressBlock
                       withResultBlock:(void (^)(id responseObject))resultBlock
                        withErrorBlock:(void (^)(HHRequestErrorType error))errorBlock isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert;


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
          progress:(void (^)(id progress))progress
            result:(void (^)(id data))result
             error:(void (^)(HHRequestErrorType errorType))errorBlock
      isSupportHud:(BOOL)isSupportHud
isSupportErrorAlert:(BOOL)isSupportErrorAlert;
@end

NS_ASSUME_NONNULL_END
