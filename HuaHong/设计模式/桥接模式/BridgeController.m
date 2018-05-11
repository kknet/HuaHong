//
//  BridgeController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/15.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BridgeController.h"
#import "SubRemote.h"
#import "TVKJ.h"
#import "XiaoMiTV.h"

@interface BridgeController ()

@end

@implementation BridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SubRemote *subRemote = [[SubRemote alloc]init];
    subRemote.tv = [[TVKJ alloc]init];
    [subRemote left];
    
    subRemote.tv = [[XiaoMiTV alloc]init];
    [subRemote down];
}
@end
