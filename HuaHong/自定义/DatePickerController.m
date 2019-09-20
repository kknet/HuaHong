//
//  DatePickerController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "DatePickerController.h"
#import "QKDatePicker.h"

@interface DatePickerController ()<QKDatePickerDelegate>
@property (nonatomic, strong) QKDatePicker *datePicker;

@end

@implementation DatePickerController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.datePicker show];
}

- (QKDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[QKDatePicker alloc]initDatePickWithDate:NSDate.date datePickerModel:UIDatePickerModeDate];
        _datePicker.delegate = self;
        [_datePicker setDateFormat:@"yyyy-MM-dd"];
    }
    
    return _datePicker;
}

//MARK: - QKDatePickerDelegate
- (void)datePicker:(QKDatePicker *)datePicker didSelectDate:(NSDate *)date StringDate:(NSString *)dateStr
{
    NSLog(@"datePicker:%@",dateStr);
    self.title = dateStr;
}

@end
