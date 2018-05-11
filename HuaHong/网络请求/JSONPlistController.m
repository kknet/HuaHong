//
//  JSONPlistController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "JSONPlistController.h"
#import "XMLModel.h"

@interface JSONPlistController ()

@end

@implementation JSONPlistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadData_Session];
}

//使用Block
-(void)loadData_Session
{
//    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.jpg"];
//    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"videos.plist"];
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"videos.json"];

    NSURL *url = [NSURL URLWithString:urlStr];
    
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        
//        UIImage *image = [UIImage imageWithData:data];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.view.layer.contents = (__bridge id)(image.CGImage);
//        });

        
          [self json:data];
//            [self plist:data];
        
    }]resume];
    
    
}


#pragma mark - json解析
-(void)json:(NSData *)data
{
    
    /**
     NSJSONReadingMutableContainers 容器节点是可变的
     NSJSONReadingMutableLeaves     子节点是可变的
     NSJSONReadingAllowFragments    允许顶级节点不是NSArray Or NSDictionary
     */
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSLog(@"result:%@",result);
    
}
#pragma mark - json序列化
-(void)toJSON
{
    XMLModel *model = [[XMLModel alloc]init];
    model.name = @"huah";
    model.length = @(22);
    [model setValue:@"华宏" forKey:@"author"];
    
    NSDictionary *dic = [model dictionaryWithValuesForKeys:@[@"name",@"length",@"author"]];
    
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:NULL];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str:%@",str);
    }
    
}

#pragma mark - plist解析
-(void)plist:(NSData *)data
{
    /**
     NSPropertyListImmutable 不可变
     NSPropertyListMutableContainers 容器可变
     NSPropertyListMutableContainersAndLeaves 容器和子节点都可变
     */
    id result = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:NULL];
    
    NSLog(@"result:%@",result);
}


@end
