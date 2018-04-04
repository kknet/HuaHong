//
//  TestViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TestViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AppDelegate+Notification.h"
//#import "CollectionHeadView.h"
//#import "HomeFlowLayout.h"

@interface TestViewController()
//@property (nonatomic,strong) UILocalNotification *localNotification;
//@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation TestViewController
{
//    BOOL _isScrollDown;//滚动方向
//    NSInteger _selectIndex;//记录位置

}

//static NSString *cellID = @"cellID";
//static NSString *headerID = @"headerID";

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    runtimeViewController *vc = [runtimeViewController new];
    [vc eat:@"123"];
    
}



@end
