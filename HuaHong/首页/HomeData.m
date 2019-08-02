//
//  HomeData.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/19.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "HomeData.h"

@implementation HomeData

+ (NSDictionary *)getData
{
    
    return @{
             @"控件":@[@"瀑布流",@"tableView",@"WKWebView",@"block",@"TextView",@"Button",@"MenuControll",@"PageControl",@"UIWebView",@"RATreeView"],
             @"定位":@[@"苹果地图",@"大头针",@"系统地图导航",@"百度地图"],
             @"传感器":@[@"光学传感器",@"3DTouch",@"指纹识别",@"距离传感器",@"重力传感器",@"碰撞",@"甩行为",@"附着行为",@"推行为",@"加速计陀螺仪磁力针",@"计步器"],
             @"音频":@[@"文字转语音",@"录音",@"语音合成"],
             @"视频":@[@"视频录制1",@"视频录制2",@"视频录制3",@"视频合成",@"自定义"],
             @"相册":@[@"相册",@"GPUImage"],
             @"通讯录":@[@"系统通讯录",@"自定义通讯录"],
             @"二维码":@[@"二维码扫描",@"二维码生成"],
             @"动画":@[@"基本动画",@"扇形加载",@"转场动画"],
             @"网络":@[@"多网络请求",@"session请求",@"下载",@"上传",@"Https证书",@"删除数据",@"XML解析",@"JSON/Plist",@"AFN"],
             @"手势交互":@[@"触摸手势交互"],
             @"数据持久化":@[@"数据存储",@"云端存储",@"CoreData",@"SQLite"],
             @"绘图":@[@"绘图",@"时钟",@"画板"],
             @"日历":@[@"日历"],
             @"图文混排":@[@"图文混排"],
             @"架构模式":@[@"MVVM",@"MVP"],
             @"图表":@[@"图表"],
             @"多线程":@[@"多线程"],
             @"编程思想":@[@"RAC",@"函数式编程",@"链式编程",@"runtime",@"runloop"],
             @"蓝牙":@[@"蓝牙",@"蓝牙外设"],
             @"智能识别":@[@"人脸识别",@"手势解锁",@"卡片识别"],
             @"设计模式":@[@"策略模式",@"桥接模式"],
             @"其他":@[@"计时器",@"密码安全",@"正则表达式",@"分段选择",@"埋点"],
             @"KVO":@[@"KVO"]
             };
    
    
    
}

+ (NSArray *)getLeftData
{
    
    return @[
             @"控件",
             @"定位",
             @"传感器",
             @"音频",
             @"视频",
             @"相册",
             @"通讯录",
             @"二维码",
             @"动画",
             @"网络",
             @"手势交互",
             @"数据持久化",
             @"绘图",
             @"日历",
             @"图文混排",
             @"架构模式",
             @"图表",
             @"多线程",
             @"编程思想",
             @"蓝牙",
             @"智能识别",
             @"设计模式",
             @"其他",
             @"KVO"
             ];
    
    
    
}

+ (NSArray *)getRightData
{
    
    return @[
             @[@"瀑布流",@"tableView",@"WKWebView",@"block",@"TextView",@"Button",@"MenuControll",@"PageControl",@"UIWebView",@"RATreeView"],
             @[@"苹果地图",@"大头针",@"系统地图导航",@"百度地图"],
             @[@"光学传感器",@"3DTouch",@"指纹识别",@"距离传感器",@"重力传感器",@"碰撞",@"甩行为",@"附着行为",@"推行为",@"加速计陀螺仪磁力针",@"计步器"],
             @[@"文字转语音",@"录音",@"语音合成"],
             @[@"视频录制1",@"视频录制2",@"视频录制3",@"视频合成",@"自定义"],
             @[@"相册",@"GPUImage"],
             @[@"系统通讯录",@"自定义通讯录"],
             @[@"二维码扫描",@"二维码生成"],
             @[@"基本动画",@"扇形加载",@"转场动画"],
             @[@"多网络请求",@"session请求",@"下载",@"上传",@"Https证书",@"删除数据",@"XML解析",@"JSON/Plist",@"AFN"],
             @[@"触摸手势交互"],
             @[@"数据存储",@"云端存储",@"CoreData",@"SQLite"],
             @[@"绘图",@"时钟",@"画板"],
             @[@"日历"],
             @[@"图文混排"],
             @[@"MVVM",@"MVP"],
             @[@"图表"],
             @[@"多线程"],
             @[@"RAC",@"函数式编程",@"链式编程",@"runtime",@"runloop"],
             @[@"蓝牙",@"蓝牙外设"],
             @[@"人脸识别",@"手势解锁",@"卡片识别"],
             @[@"策略模式",@"桥接模式"],
             @[@"计时器",@"密码安全",@"正则表达式",@"分段选择",@"埋点"],
             @[@"KVO"]
             ];
    
    
    
}
@end
