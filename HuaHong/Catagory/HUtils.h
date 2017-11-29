//
//  HUtils.h
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum ReDic
{
    Edic_l = 1,    //左边
    Edic_r = 2,    //右边
    Edic_t = 3,    //上面
    Edic_b = 4,    //下面
    
}ReDic;

@interface HUtils : NSObject

+(void)ShowAlert:(NSString*)message;
+(void)ShowMarkText:(NSString *)markString;
//+(NSString *)HiddenPhoneNummer:(NSString *)Str;

+(BOOL)isEmpty:(NSString *)Str;

+ (NSString *)getAPPName;
+(NSString*)getAppVersion;

#pragma 正则匹配
+(BOOL)checkPhone: (NSString *)Phone;

+(BOOL)checkUsername: (NSString *)Username;

+(BOOL)checkPassWord: (NSString *)PassWord;

+(BOOL)checkIdentifier: (NSString *)Identifier;


+(NSString*)formatString:(NSString*)timeString;
+(NSDate *)dateFromString:(NSString *)timeString formate:(NSString*)formate;
+(NSString *)stringFromDate:(NSDate *)date formate:(NSString*)formate;

//////////////////////////////////////////////////
+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)isPureFloat:(NSString*)string;

+(BOOL)checkNum:(NSString *)numStr;                         //验证为数字

+(BOOL)checkSFZ:(NSString *)numStr;                         //验证身份证


+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize; //缩放图片

+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW; //缩放图片,,最大多少

+(NSDate*)dateWithInt:(double)second;

+(NSDate*)getDataString:(NSString *)str bfull:(BOOL)bfull;

+(NSString*)getTimeStringHourSecond:(double)second;

+(NSString*)getTimeStringWithP:(double)time;//获取时间 2015.04.15

+(NSString*)getTimeString:(NSDate*)dat bfull:(BOOL)bfull;   //date转字符串

+(NSString*)getTimeStringHour:(NSDate*)dat;   //date转字符串 2015-03-23 08:00

+(NSString*)getTimeStringDay:(double)time;   //转字符串 2015-03-23

+(void)relPosUI:(UIView*)base dif:(CGFloat)dif tag:(UIView*)tag tagatdic:(ReDic)dic;

+(NSString *)dateForint:(double)time bfull:(BOOL)bfull;       //时间戳转字符串

+(NSString *) FormartTime:(NSDate*) compareDate;            //格式化时间

+ (BOOL)isMobileNumber:(NSString *)mobileNum;               //检测是否是手机号
+(BOOL)checkPasswdPre:(NSString *)passwd;                    //检测密码合法性

+ (NSString *)md5:(NSString *)str;

+ (NSString *)md5_16:(NSString *)str;

+(void)md5_16_b:(NSString*)str outbuffer:(char*)outbuffer;

//把nsnull字段干掉
+(NSDictionary*)delNUll:(NSDictionary*)dic;

//把nsnull字段干掉
+(NSArray*)delNullInArr:(NSArray*)arr;

//#87fd74 ==> UIColor
+(UIColor*)stringToColor:(NSString*)str;

//距离描述   dist:米
+(NSString*)getDistStr:(int)dist;

//生成微信签名
+ (NSString *)genWxSign:(NSDictionary *)signParams parentkey:(NSString*)parentkey;

+ (NSString *)genWXClientSign:(NSDictionary *)signParams;


+ (NSString *)sha1:(NSString *)input;

//+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//
//+ (NSDictionary *)getIPAddresses;

//requrl http://api.fun.com/getxxxx
//
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param;

//生成XML
+(NSString*)makeXML:(NSDictionary*)param;


+(int)gettopestV:(int)v;

+(NSString*)URLEnCode:(NSString*)str;

+(NSString*)URLDeCode:(NSString*)str;


//自动扩展,基于最后一个view的位置+高度+dif
+(void)autoExtendH:(UIView*)tagview dif:(CGFloat)dif;


//自动扩展,基于subview的位置+高度+dif
+(void)autoExtendH:(UIView*)tagview blow:(UIView*)subview dif:(CGFloat)dif;

+ (NSString *)makeImgUrl:(NSString *)bigUrl w:(CGFloat)w h:(CGFloat)h;

+ (NSString *)makeImgUrl:(NSString *)bigUrl tagImg:(UIView *)imgV;

+ (NSString *)makeImgUrl:(NSString *)bigUrl fixw:(CGFloat)fixw;


//银联支付的
+ (NSString *) readPublicKey:(NSString *) keyName;


+(BOOL) verify:(NSString *) resultStr ;



@end
