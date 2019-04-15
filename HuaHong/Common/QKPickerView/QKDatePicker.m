//
//  QKDatePicker.m
//  QK_Online
//
//  Created by 华宏 on 2019/4/15.
//  Copyright © 2019年 qk365. All rights reserved.
//

#import "QKDatePicker.h"

#define ToolbarHeight 40
@interface QKDatePicker ()

@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) NSDate *defaultDate;
@property (nonatomic,assign) NSUInteger pickHeight;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic,copy) NSString *format;
@end
@implementation QKDatePicker

-(instancetype)initDatePickWithDate:(NSDate *)defaultDate datePickerModel:(UIDatePickerMode)datePickerModel{
    
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self setupDatePickerWithDatePickerModel:datePickerModel];
        [self setToolBar];
        
    }
    
    return self;
}

-(void)setupDatePickerWithDatePickerModel:(UIDatePickerMode)datePickerModel{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerModel;
    if (_defaultDate) {
        [datePicker setDate:_defaultDate];
    }
    datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker = datePicker;
    datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-datePicker.frame.size.height, [UIScreen mainScreen].bounds.size.width, datePicker.frame.size.height);
    _pickHeight = datePicker.frame.size.height;
    [self addSubview:datePicker];

}

-(void)setToolBar
{
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-ToolbarHeight-_pickHeight, [UIScreen mainScreen].bounds.size.width, ToolbarHeight)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(remove)];
        UIBarButtonItem *centerSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(downClick)];
        _toolBar.items = @[leftItem,centerSpace,rightItem];
        [self addSubview:_toolBar];
    }
}


//设置最小可选时间
- (void)setMinimumDate:(NSDate *)maxDate
{
    [_datePicker setMinimumDate:maxDate];
}

//设置最大可选时间
- (void)setMaximumDate:(NSDate *)maxDate
{
    [_datePicker setMaximumDate:maxDate];
}

//设置日期输出格式
- (void)setDateFormat:(NSString *)format
{
    _format = format;
}

-(void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        
      [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }];
    
}

-(void)remove
{
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
    
}

-(void)downClick{
    
    _format = _format?:@"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:_format];
    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateStr = [formatter stringFromDate:_datePicker.date];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectDate:StringDate:)]) {
        [self.delegate datePicker:self didSelectDate:_datePicker.date StringDate:dateStr];
    }
    
    [self removeFromSuperview];
}

-(void)setBackgroundColor:(UIColor *)color
{
    _datePicker.backgroundColor = color;
}

@end
