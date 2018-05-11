//
//  CVSUpload.h
//  CVSUpload
//
//  Created by Leigang on 16/3/28.
//  Copyright © 2016年 Leigang. All rights reserved.
//

#ifndef VODUpload_h
#define VODUpload_h
#import <Foundation/Foundation.h>
@class UploadFileInfo;

typedef void (^OnUploadSucceedListener) (NSString* filePath);
typedef void (^OnUploadFailedListener) (NSString* filePath, long code, NSString * message);
typedef void (^OnUploadProgressListener) (NSString* filePath, long uploadedSize, long totalSize);
typedef void (^OnUploadTokenExpiredListener) ();

@protocol VODUpload <NSObject>

/**
 配置上传
 */
@required
- (BOOL)  initWithAK:(NSString *)accessKeyId
     accessKeySecret:(NSString *)accessKeySecret
         secretToken:(NSString *)secretToken
          expireTime:(NSString *)expireTime
     onUploadSucceed:(OnUploadSucceedListener)onSuccee
      onUploadFailed:(OnUploadFailedListener)onFailed
    onUploadProgress:(OnUploadProgressListener)onProgress
onUploadTokenExpired:(OnUploadTokenExpiredListener)onTokenExpired;

/**
 添加视频上传
 */
@required
- (BOOL)addFile:(NSString *)filePath
       endpoint:(NSString *)endpoint
         bucket:(NSString *)bucket
         object:(NSString *)object;


/**
 删除文件
 */
@required
- (BOOL)deleteFile:(NSString *)filePath;

@required
- (NSMutableArray<UploadFileInfo *> *)listFile;

/**
 开始上传
 */
@required
- (void)startUpload;

/**
 取消上传
 */
@required
- (void)stopUpload;

/**
 使用Token恢复上传
 */
@required
//- (void)resumeUploadWithToken(String token);
- (void)resumeUploadWithToken:(NSString *)accessKeyId
              accessKeySecret:(NSString *)accessKeySecret
                  secretToken:(NSString *)secretToken
                   expireTime:(NSString *)expireTime;

@end



#endif /* VODUpload_h */
