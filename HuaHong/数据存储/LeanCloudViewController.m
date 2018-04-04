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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addObject];
}

- (void)addObject
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


#pragma mark 更新对象
- (void)updateObject
{
    
    // 创建对象
    AVObject *post = [AVObject objectWithClassName:@"HUAHONG"];
    [post setObject:@"居有良田，食有黍稷；躬耕山間，優游人世；生之所往，不過良風年年。" forKey:@"content"];
    [post setObject:@"LeanCloud官方客服" forKey:@"pubUser"];
    [post setObject:[NSNumber numberWithInt:1435541999] forKey:@"pubTimestamp"];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        // 增加些新数据，这次只更新头像和认证等级信息
        [post setObject:@"http://tp1.sinaimg.cn/3652761852/50/5730347813/0" forKey:@"pubUserAvatar"];
        [post setObject:[NSNumber numberWithInt:4] forKey:@"pubUserCertificate"];
        [post saveInBackground];
    }];
}

#pragma mark 查询对象
-(void)query
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

@end
