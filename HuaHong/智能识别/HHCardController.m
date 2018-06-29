//
//  HHCardController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHCardController.h"
#import <ExCardSDK/ExCardSDK.h>

@interface HHCardController ()
@property (nonatomic, strong) EXOCRQuadCaptureManager *manager;

@end

@implementation HHCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.manager = [EXOCRQuadCaptureManager sharedManager:self];
    [self.manager controlTabBarControllerHiddenBySDK:NO];
    
    //初始化
    [EXOCRCardEngineManager initEngine:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.manager captureQuadCardWithCardType:EXOCRCaptureCardTypeDefault OnCompleted:^(int statusCode, EXOCRQuadCardInfo *quadInfo) {

    } OnCanceled:nil OnFailed:^(int statusCode, UIImage *recoImg) {
    }];
}



@end
