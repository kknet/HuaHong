//
//  KongJianVC.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "KongJianVC.h"

@interface KongJianVC ()

@end

@implementation KongJianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
//    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    
    NSString *timeStr = @"2017-12-11 17:22:41";
    NSDate *date = [formatter dateFromString:timeStr];
    NSTimeInterval interval = [date timeIntervalSince1970];
//    NSString * timeStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@"interval:%f",interval/(60*60*24*365));

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
