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
{
    CAShapeLayer *_layer;
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

/*****************************************/

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

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)forceOrientation:(UIInterfaceOrientation)orientation
{
    // setOrientation: 私有方法强制横屏
    if ([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        
        
    }
    
}

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
return (UIInterfaceOrientationIsLandscape(statusBarOrientation));
    
}

/** 拨打电话 */
//@"tel:%@",phoneNumber 在低版本系统无提示，直接拨打
+ (void)callPhone:(NSString *)phoneNumber
{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (void)drawCircle:(CGPoint)centerPoint
            radius:(CGFloat)radius
         lineWidth:(CGFloat)linePath
         lineColor:(CGColorRef)lineColor
        startAngle:(CGFloat)startAngle
          endAngle:(CGFloat)endAngle
         clockwise:(BOOL)clockwise
           duaring:(CFTimeInterval)duaring
          mainView:(UIView *)mainView
        layerFrame:(CGRect)layerFrame
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    _layer = [CAShapeLayer new];
    _layer.frame = layerFrame;
    //线宽
    _layer.lineWidth = linePath;
    //指定线的边缘是圆的
    _layer.lineCap = kCALineCapRound;
    //线的颜色
    _layer.strokeColor = lineColor;
    //填充色 封闭路径的填充色
    _layer.fillColor =[UIColor clearColor].CGColor;
    //添加贝塞尔路径
    _layer.path = [path CGPath];
    //开始绘制点和结束比例；strokeStart和strokeEnd可以设置一条Path的起始和终止的位置，通过利用strokeStart和strokeEnd这2个属性支持动画的特点
//    _layer.strokeStart = 0;
//    _layer.strokeEnd = 1;
    //动画：strokeEnd为CAShapeLayer的属性
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = duaring;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    [_layer addAnimation:animation forKey:@"rotation"];
    [mainView.layer addSublayer:_layer];
    
}

- (void)dismiss
{
    if (_layer != nil) {
        [_layer removeFromSuperlayer];
    }
}
@end
