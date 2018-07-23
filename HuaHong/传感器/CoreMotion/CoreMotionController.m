//
//  CoreMotionController.m
//  HuaHong
//
//  Created by 华宏 on 2018/7/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "CoreMotionController.h"
#import <CoreMotion/CoreMotion.h>

@interface CoreMotionController ()
@property (nonatomic,strong) CMMotionManager *motionMgr;
@end

@implementation CoreMotionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self accelerometerPull];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //加速计pull
//    CMAcceleration acceleration = self.motionMgr.accelerometerData.acceleration;
//    NSLog(@"x:%f,y:%f,z:%f",acceleration.x,acceleration.y,acceleration.z);
    
    
    //陀螺仪pull
//    CMRotationRate rotationRate = self.motionMgr.gyroData.rotationRate;
//    NSLog(@"x:%f,y:%f,z:%f",rotationRate.x,rotationRate.y,rotationRate.z);
    
    //磁力计pull
    CMMagneticField magneticField = self.motionMgr.magnetometerData.magneticField;
    NSLog(@"x:%f,y:%f,z:%f",magneticField.x,magneticField.y,magneticField.z);

}

#pragma mark - 加速计Pull
- (void)accelerometerPull
{
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isAccelerometerAvailable]) {
        return;
    }
    
    
    //开始采样
    [self.motionMgr startAccelerometerUpdates];
}

#pragma mark - 加速计Push
- (void)accelerometerPush {
    
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isAccelerometerAvailable]) {
        return;
    }
    
    //设计采样间隔
    self.motionMgr.accelerometerUpdateInterval = 1;
    
    //开始采样
    [self.motionMgr startAccelerometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        CMAcceleration acceleration = accelerometerData.acceleration;
        NSLog(@"x:%f,y:%f,z:%f",acceleration.x,acceleration.y,acceleration.z);
    }];
}

#pragma mark - 陀螺仪Push
- (void)gyroPush {
    
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isGyroAvailable]) {
        return;
    }
    
    //设计采样间隔
    self.motionMgr.gyroUpdateInterval = 1;
    
    //开始采样
    [self.motionMgr startGyroUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        
        CMRotationRate rotationRate = gyroData.rotationRate;
        NSLog(@"x:%f,y:%f,z:%f",rotationRate.x,rotationRate.y,rotationRate.z);

    }];
}

#pragma mark - 陀螺仪Pull
- (void)gyroPull
{
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isGyroAvailable]) {
        return;
    }
    
    
    //开始采样
    [self.motionMgr startGyroUpdates];
}

#pragma mark - 磁力计Push
- (void)magnetometerPush {
    
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isMagnetometerAvailable]) {
        return;
    }
    
    //设计采样间隔
    self.motionMgr.magnetometerUpdateInterval = 1;
    
    //开始采样
    [self.motionMgr startMagnetometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        
        CMMagneticField magneticField = magnetometerData.magneticField;
        NSLog(@"x:%f,y:%f,z:%f",magneticField.x,magneticField.y,magneticField.z);

        
    }];
}

#pragma mark - 陀螺仪Pull
- (void)magnetometerPull
{
    self.motionMgr = [CMMotionManager new];
    
    //判断是否可用
    if (![self.motionMgr isMagnetometerAvailable]) {
        return;
    }
    
    
    //开始采样
    [self.motionMgr startMagnetometerUpdates];
}


#pragma mark - 摇一摇
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//
//    [self becomeFirstResponder];
//}
//
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:YES];
//
//    [self resignFirstResponder];
//}
//
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

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
@end
