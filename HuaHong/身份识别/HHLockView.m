//
//  HHLockView.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHLockView.h"

#define kButtonCount 9
@interface HHLockView()
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *selectedArray;

@property (nonatomic,assign) CGPoint currentPoint;
@property (nonatomic,copy) NSString *pwdStr;
@end

@implementation HHLockView

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    for (UIButton *btn in self.buttonArray) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
            [self.selectedArray addObject:btn];
        }
    }
    
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    for (UIButton *btn in self.buttonArray) {
        if (CGRectContainsPoint(btn.frame, point)) {
            if (![self.selectedArray containsObject:btn])
            {
                btn.selected = YES;
                [self.selectedArray addObject:btn];

            }
        }
    }
    
    self.currentPoint = point;
    [self setNeedsDisplay];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.userInteractionEnabled = NO;
    self.currentPoint = [(UIButton *)[self.selectedArray lastObject] center];
    [self setNeedsDisplay];
    
    /** 密码 */
    NSString *pwd = @"";
    for (UIButton *btn in self.selectedArray) {
        pwd = [NSString stringWithFormat:@"%@%ld",pwd,(long)btn.tag];
    }
    self.pwdStr = pwd;
    NSLog(@"pwdStr:%@",_pwdStr);
    
    if (_lockBlock) {
        if (_lockBlock(_pwdStr))
        {
            NSLog(@"解锁成功");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.viewController.navigationController popViewControllerAnimated:YES];
            });
            
        }else
        {
            
            for (UIButton *btn in self.selectedArray) {
                btn.selected = NO;
                btn.enabled = NO;
                
                [self setNeedsDisplay];
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
     self.userInteractionEnabled = YES;

     for (UIButton *btn in self.selectedArray) {
         btn.selected = NO;
         btn.enabled = YES;

     }
        [weakSelf.selectedArray removeAllObjects];
        [weakSelf setNeedsDisplay];
    });
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = [self.buttonArray objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:@"gesture_node_normal"];
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        NSInteger count = 3;
        CGFloat space = (self.bounds.size.width - 74*3) / 4;
        
        btn.frame = CGRectMake((i%count)*(space+width)+space, (i/count)*(space+height)+space, width, height);
    }
}
-(NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
        
        for (int i = 0; i < kButtonCount; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 1;
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];
            [self addSubview:btn];
            [_buttonArray addObject:btn];

        }
    }
    
    return _buttonArray;
}

-(NSMutableArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    
    return _selectedArray;
}

- (void)drawRect:(CGRect)rect
{
    if (!self.selectedArray.count) return;
    
    NSInteger i = 0;
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (UIButton *btn in self.selectedArray) {
        if (i == 0)
        {
            [path moveToPoint:btn.center];

        }else
        {
            [path addLineToPoint:btn.center];
        }
        
        i++;
    }
   
        [path addLineToPoint:self.currentPoint];
    
        [[UIColor whiteColor] set];
        [path setLineWidth:8];
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path stroke];
        
      
}


@end
