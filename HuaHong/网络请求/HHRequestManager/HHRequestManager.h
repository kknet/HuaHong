//
//  HHRequestManager.h
//  HuaHong
//
//  Created by qk-huahong on 2019/7/1.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HHHttpSessionManager.h"
#import "MBProgressHUD+add.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RequestType) {
    GET,
    POST,
    UPLOAD
};

typedef NS_ENUM(NSUInteger, RequestErrorType) {
    
    RequestErrorNone,//无网络.
    RequestErrorJsonParseFail,//解析失败.
    RequestErrorNet404,
    RequestErrorNet500,
    RequestErrorNetOther
};

@interface HHRequestManager : NSObject

+ (instancetype)defaultManager;

@property(nonatomic, strong) HHHttpSessionManager *manager;

@property(nonatomic, copy) NSString *baseUrl;

//当前网络状态
@property(nonatomic, assign) AFNetworkReachabilityStatus netType;

//SSL证书路径
@property(nonatomic, copy) NSString *SSLCertPath;

//上传的文件
@property(nonatomic, strong) NSData *uploadFileData;

//结果处理回调
@property(nonatomic, strong) void(^filterResponseCallback)(id data,void(^continueResponseBlock)(id result));

//接口调用无网络回调
@property(nonatomic, strong) void(^noNetRequestCallback)(id params,void(^continueResponseBlock)(id params));

//网络监听
- (void)startNetMonitoring;

//设置requestHeader
- (void)setRequestHeaderField:(NSDictionary *)params;


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
                      isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert;


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
isSupportErrorAlert:(BOOL)isSupportErrorAlert;



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
                      isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert;
@end

NS_ASSUME_NONNULL_END
