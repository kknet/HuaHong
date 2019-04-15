//
//  QKDatePicker.h
//  QK_Online
//
//  Created by 华宏 on 2019/4/15.
//  Copyright © 2019年 qk365. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QKDatePicker;
@protocol QKDatePickerDelegate <NSObject>

@optional
- (void)datePicker:(QKDatePicker *)datePicker didSelectDate:(NSDate *)date StringDate:(NSString *)dateStr;
@end

@interface QKDatePicker : UIView

@property (nonatomic, assign)id<QKDatePickerDelegate> delegate;

-(instancetype)initDatePickWithDate:(NSDate *)defaultDate datePickerModel:(UIDatePickerMode)datePickerModel;

//设置最小可选时间
- (void)setMinimumDate:(NSDate *)maxDate;

//设置最大可选时间
- (void)setMaximumDate:(NSDate *)date;

//设置日期输出格式
- (void)setDateFormat:(NSString *)format;

-(void)show;

-(void)setBackgroundColor:(UIColor *)color;
@end
