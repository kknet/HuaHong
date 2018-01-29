//
//  TouchController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/26.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TouchController.h"

@interface TouchController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *hView;
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) UITapGestureRecognizer *doubleTap;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipe;
@property (strong, nonatomic) UIRotationGestureRecognizer *rotation;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@end

@implementation TouchController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 取消上一个调用的方法
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pan) object:nil];
    
//    [self.view addGestureRecognizer:self.singleTap];
//    [self.view addGestureRecognizer:self.doubleTap];
//    //双击发生时，单击失效
//    [_singleTap requireGestureRecognizerToFail:_doubleTap];
//
//    [self.view addGestureRecognizer:self.pan];
//
//    [self.view addGestureRecognizer:self.swipe];
//    //轻扫发生时，平移失效
//    [self.pan requireGestureRecognizerToFail:self.swipe];
//
//    [self.view addGestureRecognizer:self.longPress];

    [self.hView addGestureRecognizer:self.pinch];
    [self.hView addGestureRecognizer:self.rotation];

    
    
    
}

#pragma mark - 单击
-(UITapGestureRecognizer *)singleTap
{
    if (_singleTap == nil) {
        _singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
        _singleTap.numberOfTouchesRequired = 1;//手指个数
        _singleTap.numberOfTapsRequired = 1;//连续点击次数
    }
    
    return _singleTap;
}

-(void)singleTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"singleTapAction:%@",sender.view);
}

#pragma mark - 双击
-(UITapGestureRecognizer *)doubleTap
{
    if (_doubleTap == nil) {
        _doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        _doubleTap.numberOfTouchesRequired = 1;//手指个数
        _doubleTap.numberOfTapsRequired = 2;//连续点击次数
    }
    
    return _doubleTap;
}

-(void)doubleTapAction:(UITapGestureRecognizer *)sender
{
    NSLog(@"doubleTapAction:%@",sender.view);
}
#pragma mark - 平移
-(UIPanGestureRecognizer *)pan
{
    if (_pan == nil) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        _pan.minimumNumberOfTouches = 1;
        _pan.maximumNumberOfTouches = 5;
    }
    
    return _pan;
    
}

-(void)panAction:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [sender locationInView:self.view];
        NSLog(@"panBeganPoint:%@",NSStringFromCGPoint(point));
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.view];
        NSLog(@"panEndedPoint:%@",NSStringFromCGPoint(point));
        
    }
    
    CGPoint p = [sender translationInView:sender.view];
    self.hView.transform = CGAffineTransformTranslate(self.hView.transform, p.x, p.y);
    
    // 恢复到初始状态
    [sender setTranslation:CGPointZero inView:sender.view];
    
}
#pragma mark - 捏合
-(UIPinchGestureRecognizer *)pinch
{
    if (_pinch == nil) {
        _pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
        _pinch.delegate = self;

        NSLog(@"pinch scale:%f",_pinch.scale);
    }
    
    return _pinch;
    
}

-(void)pinchAction:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
        [sender.view setTransform:CGAffineTransformMakeScale(sender.scale, sender.scale)];
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
        //特殊地,transform属性默认值为CGAffineTransformIdentity,可以在形变之后设置该值以还原到最初状态
        sender.view.transform = CGAffineTransformIdentity;
        }];
    }
    NSLog(@"pinchpinch.velocity:%.2f",sender.velocity);
}
#pragma mark - 轻扫
-(UISwipeGestureRecognizer *)swipe
{
    
    if (_swipe == nil) {
        
        _swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        _swipe.numberOfTouchesRequired = 1;
        _swipe.direction = UISwipeGestureRecognizerDirectionDown;
//        _swipe.delegate = self;
    }
    
    return _swipe;
    
}
-(void)swipeAction:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"swipe");
    }
    
}
#pragma mark - 旋转
-(UIRotationGestureRecognizer *)rotation
{
    if (_rotation == nil) {
        _rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
        _rotation.delegate = self;

//        _rotation.rotation = M_PI_4;
    }
    
    return _rotation;
}

-(void)rotationAction:(UIRotationGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged) {
//        [sender.view setTransform:CGAffineTransformMakeRotation(sender.rotation)];
        [sender.view setTransform:CGAffineTransformRotate(sender.view.transform, sender.rotation)];
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
        //特殊地,transform属性默认值为CGAffineTransformIdentity,可以在形变之后设置该值以还原到最初状态
        sender.view.transform = CGAffineTransformIdentity;

        }];
    }
    NSLog(@"rotation:%.2f",sender.velocity);
}
#pragma mark - 长按
-(UILongPressGestureRecognizer *)longPress
{
    if (_longPress == nil) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        _longPress.minimumPressDuration = 0.5;
        _longPress.allowableMovement = 100;// 误差范围
    }
    
    return _longPress;
}

-(void)longPressAction:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"longPress began");
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"longPress end");

    }
}

// 解决手势冲突 缩放和旋转有冲突，任意一个设置代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return YES;
}
#pragma mark - 摇一摇
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake) {
        NSLog(@"摇一摇开始");
    }
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇结束");
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇一摇被取消");
}
/*
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     //touches.count 手指数量
    
    UITouch *touch = [touches anyObject];
    //touch.tapCount 点击次数
    
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
 
 */

/*
// 返回值：接受事件的视图
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    **
     *  1. 循环遍历当前视图的所有子视图
     *  2. 判断当前的触摸点，是否再此子视图的范围之内
     *  3. 如果触摸点在此子视图的范围之内，那么将此视图作为返回值返回
     *  4. 返回的视图对象是最终接受时间的对象，接收事件之后，调用touchesBegan方法
     *
    
    // 1.循环遍历每一个子视图
    for (UIView *subView in self.subviews) {
        
        // 2.将触摸的坐标点，转换成子视图的坐标点
        CGPoint p = [self convertPoint:point toView:subView];
        
        // 3.判断坐标点是否再此视图的范围之内
        if ([subView pointInside:p withEvent:event]) {
            return subView;
        }
        
    }
    return [super hitTest:point withEvent:event];
}
*/
@end
