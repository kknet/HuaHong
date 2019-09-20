//
//  CalendarViewController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "CalendarViewController.h"
#import "QKCalendarView.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    QKCalendarView *calendarView = [[QKCalendarView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 0)];
    [self.view addSubview:calendarView];
    [calendarView show];
    [calendarView setSelectBlock:^(NSInteger year, NSInteger month, NSInteger day) {
        NSLog(@"%ld %ld %ld",(long)year,(long)month,(long)day);
    }];
}


@end
