//
//  QKCalendarHeaderView.h
//  QKCalendarHeaderView
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import "QKCalendarHeaderView.h"

@interface QKCalendarHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@end

@implementation QKCalendarHeaderView

-(void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    
    self.dateLable.text = dateStr;
}

- (IBAction)lastMonthAction:(id)sender {
    if (_lastMonthBlock) {
        _lastMonthBlock();
    }
}


- (IBAction)nextMonthAction:(id)sender {
    if (_nextMonthBlock) {
        _nextMonthBlock();
    }
}

@end
