//
//  QKCalendarModel.h
//  QKCalendarModel
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QKCalendarModel : NSObject

- (instancetype)initWithDate:(NSDate *)date;
@property (nonatomic,strong) NSDate *currentDate;//当前传入的每一天的日期，而不是今日日期
@property (nonatomic, assign,readonly) NSInteger totalDays; //当前月的天数
@property (nonatomic, assign,readonly) NSInteger firstWeekday; //每月1号是周几（1代表周一）
@property (nonatomic, assign,readonly) NSInteger year; //所属年份
@property (nonatomic, assign,readonly) NSInteger month; //当前月份
@property (nonatomic, assign,readonly) NSUInteger row; //获取该月数据占几行
@property (nonatomic,assign,readonly) BOOL isWeekend;//是否周末
@property (nonatomic, assign,readonly) NSInteger weekday; //星期几（1代表周一，以此类推）
@property(nonatomic,assign)BOOL isLastMonth;//属于上个月的
@property(nonatomic,assign)BOOL isNextMonth;//属于下个月的
@property(nonatomic,assign)BOOL isCurrentMonth;//属于当月
@property(nonatomic,assign)BOOL isToday;//今天
@property(nonatomic,assign)BOOL isSelected;//是否被选中
@property (nonatomic, assign) NSInteger day;   //每天所在的位置
@property(nonatomic,assign)BOOL unNormal;//异常数据
@property(nonatomic,strong)UIColor *unNormalColor;//异常数据颜色

//当前月的title颜色
@property(nonatomic,strong)UIColor *currentMonthTitleColor;

//上月的title颜色
@property(nonatomic,strong)UIColor *lastMonthTitleColor;

//下月的title颜色
@property(nonatomic,strong)UIColor *nextMonthTitleColor;

//选中的背景颜色
@property(nonatomic,strong)UIColor *selectBackColor;

//今日的title颜色
@property(nonatomic,strong)UIColor *todayTitleColor;

//是否显示上月，下月的的数据
@property(nonatomic,assign)BOOL isShowLastAndNextDate;

//选中的是否动画效果
@property(nonatomic,assign)BOOL isHaveAnimation;

@end
