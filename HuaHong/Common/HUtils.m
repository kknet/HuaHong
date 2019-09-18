//
//  HHUils.m
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import "HUtils.h"
#import <CommonCrypto/CommonDigest.h>
#define kAppDelegate       [UIApplication sharedApplication].delegate

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

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allKeys = param.allKeys;
    NSMutableString* mutableStr = NSMutableString.new;
    [mutableStr appendString:@"<xml>\n"];
    for ( NSString* key in allKeys ) {
        [mutableStr appendFormat:@"<%@>%@</%@>\n",key,param[key],key];
    }
    [mutableStr appendString:@"</xml>"];
    return mutableStr;
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
    if (_layer) {
        [_layer removeFromSuperlayer];
    }
}

#pragma mark   - 获取当前控制器
/**  获取当前控制器*/
+ (UIViewController *)currentViewController{
    
    if ([kAppDelegate.window.rootViewController isKindOfClass:UINavigationController.class] || [kAppDelegate.window.rootViewController isKindOfClass:UITabBarController.class]) {
        return [self getVisibleViewControllerWithRootVC:kAppDelegate.window.rootViewController];
    }else{
        UIViewController *VC = kAppDelegate.window.rootViewController;
        if (VC.presentedViewController) {
            if ([VC.presentedViewController isKindOfClass:UINavigationController.class]||
                [VC.presentedViewController isKindOfClass:UITabBarController.class]) {
                return [self getVisibleViewControllerWithRootVC:VC.presentedViewController];
            }else{
                return VC.presentedViewController;
            }
        }
        else{
            return VC;
        }
    }
}

/**
 * 私有方法
 * rootVC必须是UINavigationController 或 UITabBarController 及其子类
 */
+ (UIViewController *)getVisibleViewControllerWithRootVC:(UIViewController *)rootVC{
    
    if ([rootVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *nav = (UINavigationController *)rootVC;
        // 如果有modal view controller并且弹起的是导航控制器，返回其topViewController
        if ([nav.visibleViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *presentdNav = (UINavigationController *)nav.visibleViewController;
            return presentdNav.visibleViewController;
        }
        else if ([nav.visibleViewController isKindOfClass:UITabBarController.class]){
            return [self getVisibleViewControllerWithRootVC:nav.visibleViewController];
        }
        // Return modal view controller if it exists. Otherwise the top view controller.
        else{
            return nav.visibleViewController;
        }
    }
    else if([rootVC isKindOfClass:UITabBarController.class]){
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        UINavigationController *nav = (UINavigationController *)tabVC.selectedViewController;
        return [self getVisibleViewControllerWithRootVC:nav];
    }else{
        return rootVC;
    }
}

@end
