//
//  QKRequestManager.h
//  HuaHong
//
//  Created by qk-huahong on 2019/7/4.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "QKHTTPSessionManager.h"
#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QKRequestType) {
    QKRequestGET,
    QKRequestPOST
};

typedef NS_ENUM(NSUInteger, QKRequestErrorType) {
    
    QKRequestErrorNone,//无网络.
    QKRequestErrorJsonParseFail,//解析失败.
    QKRequestErrorNet404,
    QKRequestErrorNet500,
    QKRequestErrorNetOther
};

@interface QKRequestManager : NSObject

+ (instancetype)defaultManager;

@property(nonatomic, strong) QKHTTPSessionManager *manager;

@property(nonatomic, copy) NSString *baseUrl;

//当前网络状态
@property(nonatomic, assign) AFNetworkReachabilityStatus netType;

//结果预处理
@property(nonatomic, strong) void(^filterResponseCallback)(id data,void(^continueResponseBlock)(id result));

//网络监听
- (void)startNetMonitoring;

//设置requestHeader
- (void)setRequestHeaderField:(NSDictionary *)params;

//SSL证书路径
- (void)setSSLCertPath:(NSString *)SSLCertPath;

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
               isSupportErrorAlert:(BOOL)isSupportErrorAlert;


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
                       failure:(void (^)(QKRequestErrorType error))errorBlock
                  isSupportHud:(BOOL)isSupportHud isSupportErrorAlert:(BOOL)isSupportErrorAlert;
@end

NS_ASSUME_NONNULL_END
