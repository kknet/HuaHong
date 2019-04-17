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
    _label.textColor = [UIColor darkGrayColor];
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
            if (model.isNextMonth)
            {
                self.label.textColor = model.nextMonthTitleColor;
            }
            
            if (model.isLastMonth)
            {
                self.label.textColor = model.lastMonthTitleColor;
            }
            
            
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
            self.label.backgroundColor = model.todayTitleColor;
        }
        
        if (model.isWeekend)
        {
            self.label.textColor = [UIColor redColor];
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
    
    //异常数据
    if (_model.unNormal) {
        [self.label setCornerRadius:self.label.width/2];
        self.label.backgroundColor = model.unNormalColor;
        
    }
    
}
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.values = @[@0.6,@1.2,@1.0];
    
    // transform.scale 表示长和宽都缩放
    anim.keyPath = @"transform.scale";
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;
    anim.repeatCount = 1;//MAXFLOAT
    
    // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    anim.autoreverses = NO;
    
    [self.label.layer addAnimation:anim forKey:nil];
}
@end
