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

+(BOOL)checkPasswdPre:(NSString *)passwd;                    //检测密码合法性

//把nsnull字段干掉
+(NSDictionary*)delNUll:(NSDictionary*)dic;

//把nsnull字段干掉
+(NSArray*)delNullInArr:(NSArray*)arr;

//#87fd74 ==> UIColor
+(UIColor*)stringToColor:(NSString*)str;

//距离描述   dist:米
+(NSString*)getDistStr:(int)dist;

//url 拼接参数
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param;

//生成XML
+(NSString*)makeXML:(NSDictionary*)param;

//根据颜色生成图片
+(UIImage *)imageWithColor:(UIColor *)color;

@end
