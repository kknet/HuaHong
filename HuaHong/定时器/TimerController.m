//
//  TimerController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/30.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TimerController.h"
#import <objc/runtime.h>
#import "HHProxy.h"

@interface TimerController ()
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) CADisplayLink *displaylink;
@property (nonatomic,strong) NSTimer *nsTimer;
@property (nonatomic,strong) id target;
@property (nonatomic,strong) HHProxy *proxy;
@end

@implementation TimerController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self NSTimerMothod];
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [_displaylink invalidate];
    
//    [_nsTimer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - GCD
/**
 * 延迟调用
 */
-(void)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        self.view.backgroundColor = [UIColor cyanColor];
    });
    
    /**
     * 延迟方法二
     */
//    [self performSelector:@selector(timeAction) withObject:nil afterDelay:3.0];
    
    //取消延时调用
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeAction) object:nil];
    
    
    /**
     * 延迟方法三
     */
//    [NSThread sleepForTimeInterval:3.0];
}

/**
 * 通常timer设为全局变量，否则方法不执行
 * 若timer为局部变量，必须在dispatch_source_set_event_handler中注销，且只执行一次；dispatch_source_cancel(timer);
     timer=nil;
 */
-(void)GCDTimer1
{
        dispatch_queue_t queue = dispatch_get_main_queue();
       __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval, 0);
        dispatch_source_set_event_handler(timer, ^{
    
            dispatch_source_cancel(timer);
            timer = nil;
            
            NSLog(@"gcd");
    
    
        });
    
        // 启动定时器
        dispatch_resume(timer);
}

/**
 * start：第二个参数是延迟时间，若不想延迟，start直接使用 DISPATCH_TIME_NOW
 */
-(void)GCDTimer2
{
    __weak typeof(self) weakSelf = self;

    dispatch_queue_t queue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(3.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(_timer, start, interval, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        NSLog(@"gcd");
        
        [weakSelf timeAction:nil];
        
    });
    
    // 启动定时器
    dispatch_resume(_timer);
}



#pragma mark - CADisplayLink
/**
 * CADisplayLink 用于屏幕渲染，一秒刷新60次
 */
-(void)CADisplayLinkMothod
{
    _displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeAction:)];
 [_displaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}



#pragma mark - NSTimer
/**
 * NSTimer 经过间隔时间才开始执行; [timer fire]立刻执行
 */

/** 方法一 */
//- (void)didMoveToParentViewController:(UIViewController *)parent
//{
//    NSLog(@"parent:%@",parent);
//    if (parent == nil)
//    {
//        [_nsTimer invalidate];//必须
//        _nsTimer = nil;
//
//        [_displaylink invalidate];
//    }
//}

-(void)NSTimerMothod
{
    __weak typeof(self) weakSelf = self;
    
    /**
     * 方法二
     * 需要在dealloc invalidate
     */
//    _nsTimer =  [NSTimer hhscheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer:%@",timer);
//        [weakSelf timeAction:nil];
//    }];
    
    
    /** 方法三 */
    _target = [NSObject new];
    
    //动态添加方法
//    Method method = class_getInstanceMethod([self class], @selector(timeAction:));
//    class_addMethod([_target class], @selector(timeAction:), method_getImplementation(method), "v@:@");
//
//    //    class_addMethod([_target class], @selector(timeAction:), (IMP)dynamicFunction, "v@:@");
//
//    _nsTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:_target selector:@selector(timeAction:) userInfo:self repeats:YES];
    
     /** 方法四 */
    _proxy = [HHProxy alloc];
    _proxy.target = self;
    _nsTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:_proxy selector:@selector(timeAction:) userInfo:nil repeats:YES];
    
    [_nsTimer fire];
}


void dynamicFunction(id self ,SEL _cmd,id objc)
{
    NSLog(@"self:%@",self);
    NSLog(@"_cmd:%@",NSStringFromSelector(_cmd));
    NSLog(@"objc:%@",objc);

    NSTimer *timer = (NSTimer *)objc;
    TimerController *vc = (TimerController *)timer.userInfo;
    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
//    NSLog(@"vc:%@",vc);
    
}



/**
 * 执行方法
 */
-(void)timeAction:(id)sender
{
    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
//    NSTimer *timer = (NSTimer *)sender;
//    TimerController *vc = (TimerController *)timer.userInfo;
//    vc.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
    
}

- (void)dealloc
{
    [_nsTimer invalidate];
    _nsTimer = nil;
    
    NSLog(@"%s",__func__);
}
@end
