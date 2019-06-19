//
//  HUtils.h
//  CommunityBuyer
//
//  Created by 华宏 on 16/5/7.
//  Copyright © 2016年 zdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HUtils : NSObject

+ (NSString *)getAPPName;
+(NSString*)getAppVersion;

//////////////////////////////////////////////////

//url 拼接参数
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param;

//生成XML
+(NSString*)makeXML:(NSDictionary*)param;

/**
 *  切换横竖屏
 *
 *  @param orientation UIInterfaceOrientation
 */
+ (void)forceOrientation:(UIInterfaceOrientation)orientation;

/**
 *  是否是横屏
 *
 *  @return 是 返回yes
 */
+ (BOOL)isOrientationLandscape;

/** 拨打电话 */
+ (void)callPhone:(NSString *)phoneNumber;

/**
 绘制圆形
 
 @param centerPoint 中心点
 @param radius 半径
 @param linePath 线宽
 @param lineColor 线的颜色
 @param startAngle 开始圆角
 @param endAngle 结束圆角
 @param clockwise 是否是顺时针
 @param duaring 动画事件
 @param mainView 圆环或圆所在的父视图
 @param layerFrame layer的frame
 */
- (void)drawCircle:(CGPoint)centerPoint
            radius:(CGFloat)radius
         lineWidth:(CGFloat)linePath
         lineColor:(CGColorRef)lineColor
        startAngle:(CGFloat)startAngle
          endAngle:(CGFloat)endAngle
         clockwise:(BOOL)clockwise
           duaring:(CFTimeInterval)duaring
          mainView:(UIView *)mainView
        layerFrame:(CGRect)layerFrame;

- (void)dismiss;

@end
