//
//  TouchController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TouchController.h"

@interface TouchController ()
@property (strong, nonatomic) IBOutlet UIView *hView;

@end

@implementation TouchController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point1 = [touch locationInView:self.hView];
    if (!CGRectContainsPoint(self.hView.bounds, point1)) {
        return;
    }

    //拖动view，方法一
    CGPoint point = [touch locationInView:self.view];
    self.hView.center = point;
    
    //拖动view，方法二
//    CGPoint previousPoint = [touch previousLocationInView:self.view];
//    CGPoint currentPoint = [touch locationInView:self.view];
//    CGFloat offsetX = currentPoint.x - previousPoint.x;
//    CGFloat offsetY = currentPoint.y - previousPoint.y;
//    CGPoint center = CGPointMake(self.hView.center.x + offsetX, self.hView.center.y + offsetY);
//    self.hView.center = center;
}
@end
