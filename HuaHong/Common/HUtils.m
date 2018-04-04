//
//  HHUils.m
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "HUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HUtils

+(void)ShowAlert:(NSString *)message{
    UIAlertView* alert ;
    
    if (alert==nil) {
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    }
    
    [alert show];
    alert = nil;
    
    
}


+ (NSString *)getAPPName{
    
    NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    
    return AppName;
    
}

+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+(BOOL)checkPhone: (NSString *)Phone{
    NSString * regex = @"^1+[345678]+\\d{9}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Phone];
    return isMatch;
}
+(BOOL)checkUsername: (NSString *)Username{
    NSString * regex = @"^[A-Za-z]+[0-9]*$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Username];
    return isMatch;
}

+(BOOL)checkPassWord: (NSString *)PassWord{
    NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,20}";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:PassWord];
    return isMatch;
}

+(BOOL)checkIdentifier: (NSString *)Identifier{
    NSString * regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:Identifier];
    return isMatch;
    
}

+(NSString*)formatString:(NSString*)timeString{
    
    
    
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *date = [self dateFromString:timeString formate:formate];
    
    NSTimeInterval time = [[NSDate new] timeIntervalSinceDate:date];
    
    //    如果小于一天
    if (time<24*60*60) {
        
        if (time<60*60) {
            
            
            return [NSString stringWithFormat:@"%d分钟前",(int)time/60];
        }
        
        return [NSString stringWithFormat:@"%d小时前",(int)time/60/60];
        
    }
    
    
    return [self stringFromDate:date formate:@"MM-dd HH:mm"];
}


+(NSDate *)dateFromString:(NSString *)timeString formate:(NSString*)formate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return  [formatter dateFromString:timeString];
}


+(NSString *)stringFromDate:(NSDate *)date formate:(NSString*)formate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return  [formatter stringFromDate:date];
}


//显示提示语言
+(void)ShowMarkText:(NSString *)markString
{
    UILabel *label = (UILabel *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] viewWithTag:1124];
    [label removeFromSuperview];
    
    UILabel *markLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-50)/2, [UIScreen mainScreen].bounds.size.width-50*2, 50)];
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.alpha =1;
    markLabel.textColor = [UIColor whiteColor];
    markLabel.text = markString;
    markLabel.numberOfLines = 0;
    markLabel.tag = 1124;
    markLabel.layer.cornerRadius = 4;
    markLabel.layer.masksToBounds = YES;
    markLabel.font = [UIFont boldSystemFontOfSize:15];
    markLabel.center = CGPointMake([(AppDelegate *)[[UIApplication sharedApplication] delegate] window].frame.size.width/2, [(AppDelegate *)[[UIApplication sharedApplication] delegate] window].frame.size.height/2-40);
    markLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    
    
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] addSubview:markLabel];
    
    [UIView animateWithDuration:2 delay:1 options:2 animations:^{
        markLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [markLabel removeFromSuperview];
    }];
    
    markLabel = nil;
}

/*****************************************/

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (BOOL)checkNum:(NSString *)numStr{
    
    if( [self isPureInt:numStr] || [self isPureFloat:numStr]){
        
        return YES;
        
    }
    return NO;
}


+(BOOL)checkSFZ:(NSString *)numStr
{
    if( numStr == nil || [numStr length] != 18 )
    {
        return NO;
    }
    
    char string_idnum[19];  // 身份证号码，最后一位留空，一会算出来最后一位
    
    char verifymap[] = "10X98765432";  // 加权乘积求和除以11的余数所对应的校验数
    
    int factor[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1};  // 加权因子
    
    long sum = 0l;  //加权乘积求和
    
    int m = 0;  // 加权乘积求和的模数
    
    char * p = string_idnum;  // 当前位置
    
    memset(string_idnum, 0, sizeof(string_idnum));  // 清零
    
    const char* snum = [numStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    strcpy(string_idnum, snum);  // 本体码，也就是前17位
    string_idnum[17] = '\0';
    
    while(*p)  // 在 '\0' 之前一直成立
        
    {
        
        sum += (*p - '0') * factor[p - string_idnum];  // 加权乘积求和
        
        p++;  // 当前位置增加1
        
    }
    
    m = sum % 11;  // 取模
    
    return verifymap[m] == snum[17];
}
+(NSDate*)dateWithInt:(double)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}
+(NSString*)getTimeStringHourSecond:(double)second
{
    return [HUtils getTimeStringHour: [HUtils dateWithInt:second] ];
}

+(NSString *)dateForint:(double)time bfull:(BOOL)bfull
{
    NSDate *date = [HUtils dateWithInt:time];
    return [HUtils getTimeString:date bfull:bfull];
}

+(NSDate*)getDataString:(NSString *)str bfull:(BOOL)bfull{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSDate *Date = [dateFormatter dateFromString:str];
    return Date;
}

+(NSString*)getTimeString:(NSDate*)dat bfull:(BOOL)bfull
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSString *strDate = [dateFormatter stringFromDate:dat];
    if( bfull ) return strDate;
    
    //  NSString *nodatetring = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+(NSString*)getTimeStringWithP:(double)time
{
    NSDate *date = [HUtils dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString*)getTimeStringHour:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringDay:(double)time   //转字符串 2015-03-23
{
    NSDate *date = [HUtils dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *) FormartTime:(NSDate*) compareDate
{
    
    if( compareDate == nil ) return @"";
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = timeInterval;
    NSString *result;
    
    if (timeInterval < 60) {
        if( temp == 0 )
            result = @"刚刚";
        else
            result = [NSString stringWithFormat:@"%d秒前",(int)temp];
    }
    else if(( timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",(int)temp/60];
    }
    
    else if(( temp/86400) <30){
        
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"dd"];
        NSString *str = [date stringFromDate:[NSDate date]];
        int nowday = [str intValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        int day = [strDate intValue];
        if (nowday-day==0) {
            [dateFormatter setDateFormat:@"今天 HH:mm"];
            result =    [dateFormatter stringFromDate:compareDate];
        }
        else if(nowday-day==1)
        {
            
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            result =  [dateFormatter stringFromDate:compareDate];
            
            
        }
        
        
        else if( temp < 8 )
        {
            if (temp==1) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            else if(temp == 2)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"前天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:compareDate];
            result = strDate;
            
        }
    }
    else
    {//超过一个月的就直接显示时间了
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        result = strDate;
    }
    
    /*
     else if((temp = (temp/(3600*24))/30) <12){
     result = [NSString stringWithFormat:@"%d个月前",(int)temp];
     }
     else{
     temp = temp/12;
     result = [NSString stringWithFormat:@"%d年前",(int)temp];
     }
     */
    
    return  result;
}

+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW //缩放图片,,最大多少
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    
    if( org.size.width > maxW )
    {
        w = maxW;
        h = (w / org.size.width) * org.size.height;
    }
    else
    {
        w = org.size.width;
        h = org.size.height;
        return org;
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//缩放图片
+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    if( org.size.width > org.size.height )
    {
        if( org.size.width > maxsize )
        {
            w = maxsize;
            h = (w / org.size.width) * org.size.height;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    else
    {
        if( org.size.height > maxsize )
        {
            h = maxsize;
            w = (h / org.size.height) * org.size.width;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}



+(BOOL)checkPasswdPre:(NSString *)passwd
{
    if (passwd.length<6||passwd.length>20) {
        return NO;
    }
    return YES;
}

+(NSDictionary*)delNUll:(NSDictionary*)dic
{
    NSArray* allk = dic.allKeys;
    NSMutableDictionary* tmp = NSMutableDictionary.new;
    for ( NSString* onek in allk ) {
        id v = [dic objectForKey:onek];
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [HUtils delNullInArr:v] ;
            [tmp setObject:ta forKey:onek];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [HUtils delNUll:v];
            [tmp setObject:td forKey:onek];
            continue;
        }
        [tmp setObject:v forKey:onek];
    }
    return tmp;
}
+(NSArray*)delNullInArr:(NSArray*)arr
{
    NSMutableArray* tmp = NSMutableArray.new;
    for ( id v in arr ) {
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [HUtils delNullInArr:v] ;
            [tmp addObject:ta];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [HUtils delNUll:v];
            [tmp addObject:td];
            continue;
        }
        [tmp addObject:v];
    }
    return tmp;
}

+(UIColor*)stringToColor:(NSString*)str
{
    if( str.length != 7 ) return nil;
    //#54fd13
    NSString* r = [str substringWithRange:NSMakeRange(1, 2)];
    unsigned long rv = strtoul( [r UTF8String] , NULL, 16);
    
    NSString* g = [str substringWithRange:NSMakeRange(3, 2)];
    unsigned long gv = strtoul( [g UTF8String] , NULL, 16);
    
    NSString* b = [str substringWithRange:NSMakeRange(5, 2)];
    unsigned long bv = strtoul( [b UTF8String] , NULL, 16);
    
    return COLOR(rv,gv,bv,1.0);
}

+(NSString*)getDistStr:(int)dist
{
    if( dist < 1000 )
        return [NSString stringWithFormat:@"%dm",dist];
    else if( dist < 1000*1000 )
        return [NSString stringWithFormat:@"%.2fkm",(float)dist/1000];
    else
        return @">1000km";
}

//url 拼接参数
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param
{
    if( param.count == 0 ) return requrl;
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"%@=%@&",onek,param[onek]];
    }
    return [NSString stringWithFormat:@"%@?%@",requrl,[reqstr substringToIndex:reqstr.length-2]];
}

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    [reqstr appendString:@"<xml>\n"];
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"<%@>%@</%@>\n",onek,param[onek],onek];
    }
    [reqstr appendString:@"</xml>"];
    return reqstr;
}

//根据颜色生成图片
+(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
