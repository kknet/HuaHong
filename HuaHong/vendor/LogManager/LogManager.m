////
////  LogManager.m
////  QkRepair
////
////  Created by qk365 on 17/4/18.
////  Copyright © 2017年 qk365. All rights reserved.
////
//
//#import "LogManager.h"
//#import <UIKit/UIKit.h>
//#import <sys/utsname.h>
//#import <AliyunOSSiOS/OSSService.h>
//
//NSString *const AccessKey = @"LTAIIwBxoAgbgt1K";
//NSString *const SecretKey = @"hc3OLRPwDVu9DIJoTab7LCja6QrCpe";
//NSString *const bucketName = @"ios-qk365";
//NSString *const endPoint = @"oss-cn-shanghai.aliyuncs.com";
//
//
//typedef enum:NSInteger{
//    LogStatusDefault,
//    LogStatusExpire,     //过期
//    LogStatusNewCreate,  //新建
//}LogStatusType;
//
//
//@implementation LogManager
//
//+ (instancetype)sharedLogManager {
//    static LogManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[LogManager alloc] init];
//    });
//    return manager;
//}
//
//- (void)redirectNSlogToDocumentFolder
//{
//
//    if (isatty(STDOUT_FILENO)) {
//        return;
//    }
//
//    UIDevice *device = [UIDevice currentDevice];
//    if ([[device model] isEqualToString:@"Simulator"]) {
//        return;
//    }
//
//
//    //保存日志的路径
//    NSString *logFileDir = [self fileDir];
//    //先删除已经存在的文件
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL fileExist = [fileManager fileExistsAtPath:logFileDir];
//    if (!fileExist) {
//        [fileManager createDirectoryAtPath:logFileDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    NSString *logFilePath = [logFileDir stringByAppendingFormat:@"/%@-%@.text",_projectName,[self timeStr]];
//    //将log输入到文件
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
//    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
//
//
//
//
//
//    //收集崩溃日志:注册消息处理函数的处理方法
//
//}
//- (NSString *)fileDir {
//    NSString *fileName = @"log";
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [paths objectAtIndex:0];
//    NSString *fileDir = [documentDirectory stringByAppendingPathComponent:fileName];
//    return fileDir;
//}
//
//void uncaughtExceptionHandler(NSException *exception)
//{
//    //异常的堆栈信息
//    NSArray *stackArray = [exception callStackSymbols];
//    //出现异常的原因
//    NSString *reason = [exception reason];
//    //异常名称
//    NSString *name = [exception name];
//    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason:%@\nException name:%@\nException stack:%@",name,reason,stackArray];
//    NSLog(@"%@",exceptionInfo);
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
//    [tmpArr insertObject:reason atIndex:0];
//    NSString *fileName = @"crash";
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//
//    NSString *filePath = [paths[0] stringByAppendingPathComponent:fileName];
//
//    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//
//    //保存到本地 --可以在下次启动的时候，上传这个log
//    [exceptionInfo writeToFile:@"" atomically:YES encoding:NSUTF8StringEncoding error:nil];
//
//}
//
//OSSClient *client;
//- (void)uploadLocalLog {
//    NSString *fileDir = [self fileDir];
//    //查找是否有log文件
//    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:[self fileDir]];
//    if (files.count > 0) {
//        //上传阿里云
//        [OSSLog enableLog];
//        id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];
//        OSSClientConfiguration *conf = [OSSClientConfiguration new];
//        conf.maxRetryCount = 2;
//        conf.timeoutIntervalForRequest = 30;
//        conf.timeoutIntervalForResource = 24 * 60 * 60;
//
//        client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
//
//        for (NSString *fileName in files) {
//            NSString *filePath = [fileDir stringByAppendingFormat:@"/%@",fileName];
//            NSLog(@"filePath = %@",filePath);
//            if ([self checkLogIsExpire:fileName]==LogStatusExpire) {  //如果已经过期，直接删除
//                NSError *error;
//                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//                if (error) {
//                    NSLog(@"过期日志删除失败:%@",error);
//                }
//                continue;
//            }
//            else if ([self checkLogIsExpire:fileName]==LogStatusNewCreate) {  //如果新建的，直接跳过，暂时不上传
//                continue;
//            }
//            NSDictionary *fileDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
//            if (fileDic && fileDic.fileSize>20*pow(10, 6)) {  //如果日志文件超过20M，直接删除
//                NSError *error;
//                [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//                if (error) {
//                    NSLog(@"异常日志删除失败:%@",error);
//                }
//                continue;
//            }
//            [self uploadOnjectAsync:filePath fileName:fileName];
//        }
//    }
//
//}
//
////异步上传
//- (void)uploadOnjectAsync:(NSString *)filePath fileName:(NSString *)fileName {
//    OSSPutObjectRequest *put = [OSSPutObjectRequest new];
//    put.bucketName = bucketName;
//    put.objectKey = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",_projectName,[self dateStr],_userName,[self iphone],fileName];
//    put.uploadingFileURL = [NSURL fileURLWithPath:filePath];
//
//    //optional fields
//    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
//
//    };
//    put.contentType = @"";
//    put.contentMd5 = @"";
//    put.contentEncoding = @"";
//    put.contentDisposition = @"";
//
//    OSSTask *putTask = [client putObject:put];
//    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
//        if (!task.error) {
//            NSLog(@"upload object success!");
//            //删除本地的log文件
//            NSError *error;
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//            if (error) {
//                NSLog(@"删除失败:%@",error);
//            }
//        } else {
//            NSLog(@"upload object failed,error: %@",task.error);
//        }
//        return nil;
//    }];
//
//
//}
//
//- (NSString *)dateStr {
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"CCD"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    [formatter setTimeZone:timeZone];
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
//    return dateStr;
//}
//
//- (NSString *)timeStr {
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
//    [formatter setTimeZone:timeZone];
//    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
//    return timeStr;
//}
//
//- (NSString *)iphone {
//    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSString *phoneModel = [self iphoneType];
//    return  [NSString stringWithFormat:@"%@.%@",phoneModel,phoneVersion];
//}
//
//- (NSString *)iphoneType {
//
//    struct utsname systemInfo;
//
//    uname(&systemInfo);
//
//    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
//
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
//
//    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
//
//    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
//
//    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
//
//    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
//
//    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
//
//    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
//
//    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
//
//    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
//
//    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
//
//    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
//
//    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
//
//    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//
//    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
//
//    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
//
//    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
//
//    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
//
//    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
//
//    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
//
//    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
//
//    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
//
//    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
//
//    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
//
//    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
//
//    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
//
//    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
//
//    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
//
//    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
//
//    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
//
//    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
//
//    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
//
//    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
//
//    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
//
//    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
//
//    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
//
//    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
//
//    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
//
//    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
//
//    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
//
//    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
//
//    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
//
//    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
//
//    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
//
//    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
//
//    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
//
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
//
//    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
//
//    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
//
//    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
//
//    return platform;
//
//}
//
//
//- (NSDate *)timeStrToDate:(NSString *)timeStr
//{
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"zh_CN"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
//    [formatter setTimeZone:timeZone];
//    NSDate *timeDate = [formatter dateFromString:timeStr];
//    return timeDate;
//}
//
//- (LogStatusType)checkLogIsExpire:(NSString *)fileName
//{
//    NSString *fileDateStr = [fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-",_projectName] withString:@""];
//    fileDateStr = [fileDateStr stringByReplacingOccurrencesOfString:@".text" withString:@""];
//    NSDate *fileDate = [self timeStrToDate:fileDateStr];
//    NSTimeInterval interval = [fileDate timeIntervalSinceNow];
//    if (interval<-3600*24) {  //超过24小时，过期
//        return LogStatusExpire;
//    }
//    else if(interval>-10)   //10秒以内的表示新建的文件，不需要上传
//    {
//        return LogStatusNewCreate;
//    }
//    return LogStatusDefault;
//}
//
//@end
