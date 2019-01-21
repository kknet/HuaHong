//
//  LeanCloudViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LeanCloudViewController.h"
//#import <AVOSCloud/AVOSCloud.h>

@interface LeanCloudViewController ()

@end

@implementation LeanCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSArray *)getTableViewArray
{
    return @[@"控件",@"定位",@"传感器",@"音频",@"视频",@"相册",@"通讯录",@"二维码",@"动画",@"网络",@"手势交互",@"数据持久化",@"绘图",@"日历",@"图文混排",@"架构模式",@"图表",@"多线程",@"编程思想",@"蓝牙",@"智能识别",@"设计模式",@"其他",@"KVO"];
}

- (NSArray *)getCollectionViewArray
{
    return  @[
              @[@"瀑布流",@"tableView",@"WKWebView",@"block",@"TextView",@"Button",@"MenuControll",@"PageControl",@"UIWebView",@"RATreeView"],
              @[@"苹果地图" ,@"大头针",@"系统地图导航",@"百度地图"],
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
              @[@"计时器",@"密码安全",@"正则表达式",@"分段选择"],
              @[@"KVO"]
              ];
}


- (IBAction)addAction
{
    
    AVObject *todo = [AVObject objectWithClassName:@"HomeDadaSource"];
    [todo setObject:[self getTableViewArray] forKey:@"table"];
    [todo setObject:[self getCollectionViewArray] forKey:@"collection"];
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"存储成功"];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"存储失败"];

        }
    }];
    
//    使用上面的后台存储
//    [todo save];
}

#pragma mark 删除
-(IBAction)deleteAction
{
    // 查询对象
    
    //1. 指定查询的表名
    AVQuery *query = [AVQuery queryWithClassName:@"HomeDadaSource"];
    
    //2. 设置查询条件
    [query whereKey:@"content" containsString:@"会议"];
    //    [query whereKey:@"content" equalTo:@"会议"];
    
    //3. 执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3.1 防错处理
        if (error) {
            NSLog(@"查询出错");
            return;
        }
        
        //3.2 获取查询到的对象
        for (AVObject *object in objects) {
            NSLog(@"object:%@",object);
            
            //4. 删除对象
            [object removeObjectForKey:@"content"];
            
            
            // 字段删除后结果保存到云端
            [object saveInBackground];
            
        }
        
        
        NSLog(@"count: %ld",objects.count);
    }];
}

#pragma mark 更新对象
- (IBAction)updateAction
{
    
    // 查询对象
    
    //1. 指定查询的表名
    AVQuery *query = [AVQuery queryWithClassName:@"HomeDadaSource"];
    
    //2. 设置查询条件
    [query whereKey:@"content" containsString:@"会议"];
    //    [query whereKey:@"content" equalTo:@"会议"];
    
    //3. 执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3.1 防错处理
        if (error) {
            NSLog(@"查询出错");
            return;
        }
        
        //3.2 获取查询到的对象
        for (AVObject *object in objects)
        {
            [object setObject:@"会议，object" forKey:@"content"];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    NSLog(@"修改成功");
                } else {
                    NSLog(@"修改失败");
                    
                }
            }];
        }
        
        
        NSLog(@"count: %ld",objects.count);
    }];
}

#pragma mark 查询对象
-(IBAction)queryAction
{
    // 查询对象
    
    //1. 指定查询的表名
    AVQuery *query = [AVQuery queryWithClassName:@"HomeDadaSource"];
    
    //2. 设置查询条件
    [query whereKey:@"content" containsString:@"会议"];
//    [query whereKey:@"content" equalTo:@"会议"];

    //3. 执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3.1 防错处理
        if (error) {
            NSLog(@"查询出错");
            return;
        }
        
        //3.2 获取查询到的对象
        for (AVObject *object in objects)
        {
            NSLog(@"object:%@",object);
        }
        
        
        NSLog(@"count: %ld",objects.count);
    }];
    
}

@end
