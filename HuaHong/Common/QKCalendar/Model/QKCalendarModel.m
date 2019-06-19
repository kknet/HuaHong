
//
//  QKCalendarModel.h
//  QKCalendarModel
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import "QKCalendarModel.h"
#import "NSDate+Calendar.h"

@implementation QKCalendarModel

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        _currentDate = date;
        
        _totalDays = [date totalDaysInMonth];
        _firstWeekday = [date firstWeekDayInMonth];
        _year = date.year;
        _month = date.month;
        _weekday = [NSDate weekdayFromDate:date];
        _isWeekend = (_weekday == 6 || _weekday == 7)? YES:NO;
        _row = ceil((_firstWeekday + _totalDays - 1)/7.0);
        
    }
    
    return self;
    
}

- (void)setDay:(NSInteger)day
{
    _day = day;
    
    //标识是今天
    _isToday = ((_year == NSDate.date.year) && (_month == NSDate.date.month) && (_day == NSDate.date.day))?YES:NO;
}
@end
