//
//  LeanCloudViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LeanCloudViewController.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LeanCloudViewController ()

@end

@implementation LeanCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)addAction
{
    AVObject *todo = [AVObject objectWithClassName:@"HUAHONG"];
    [todo setObject:@"工程师周会" forKey:@"title"];
    [todo setObject:@"每周工程师会议，周一下午2点" forKey:@"content"];
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"存储成功");
        } else {
            NSLog(@"存储失败");

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
    AVQuery *query = [AVQuery queryWithClassName:@"HUAHONG"];
    
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
    AVQuery *query = [AVQuery queryWithClassName:@"HUAHONG"];
    
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
    AVQuery *query = [AVQuery queryWithClassName:@"HUAHONG"];
    
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
