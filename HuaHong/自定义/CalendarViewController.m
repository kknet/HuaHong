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
@property (strong,nonatomic) QKCalendarView *calendarView;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.calendarView show];

}

- (QKCalendarView *)calendarView
{
    if (_calendarView == nil) {
        _calendarView = [[QKCalendarView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.width, 0)];
        _calendarView.selectBackColor = UIColor.redColor;
        [self.view addSubview:_calendarView];

        [_calendarView setSelectBlock:^(NSInteger year, NSInteger month, NSInteger day) {
            NSLog(@"%ld-%ld-%ld",(long)year,(long)month,(long)day);
        }];
    }
    
    return _calendarView;
}
@end
