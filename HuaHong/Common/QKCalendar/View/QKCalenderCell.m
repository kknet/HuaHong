//
//  QKCalenderCell.h
//  QKCalenderCell
//
//  Created by 华宏 on 2019/4/14.
//  Copyright © 2019年  All rights reserved.
//

#import "QKCalenderCell.h"
#import "UIView+Extension.h"

@interface QKCalenderCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation QKCalenderCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    _label.backgroundColor = [UIColor clearColor];
}

-(void)setModel:(QKCalendarModel *)model
{
    _model = model;
    
    self.label.text = [NSString stringWithFormat:@"%ld",model.day];
    
    if (model.isNextMonth || model.isLastMonth) {
        self.userInteractionEnabled = NO;
        
        if (model.isShowLastAndNextDate)
        {
            self.label.hidden = NO;
            self.label.textColor = model.nextMonthTitleColor;
            self.label.textColor = model.lastMonthTitleColor;
            
        }else{
            
            self.label.hidden = YES;
        }
        
        
    }else{
        
        self.label.hidden = NO;
        self.userInteractionEnabled = YES;
        
        self.label.textColor = model.currentMonthTitleColor;
        
        if (model.isToday)
        {
            [self.label setCornerRadius:self.label.width/2];
            self.label.textColor = model.todayTitleColor;
        }
        
        if (model.isSelected)
        {
            [self.label setCornerRadius:self.label.width/2];
            self.label.backgroundColor = model.selectBackColor;
            self.label.textColor = [UIColor whiteColor];
            
            if (model.isHaveAnimation) {
                [self addAnimaiton];
            }
            
        }
    }
    
    
}
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.values = @[@0.6,@1.2,@1.0];
    anim.keyPath = @"transform.scale";
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    anim.repeatCount = 1;//MAXFLOAT
    anim.autoreverses = NO;
    
    [self.label.layer addAnimation:anim forKey:nil];
}
@end
