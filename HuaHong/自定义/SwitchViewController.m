//
//  SwitchViewController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "SwitchViewController.h"
#import "HHSwitch.h"

@interface SwitchViewController ()
@property (nonatomic,strong) HHSwitch *hhswitch;
@end

@implementation SwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.view addSubview:self.hhswitch];
    
}

- (HHSwitch *)hhswitch{
   
    if (_hhswitch == nil) {
        _hhswitch = [[HHSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 0)];
        _hhswitch.center = self.view.center;
        _hhswitch.onText = @"开启";
        _hhswitch.offText = @"关闭";
        [_hhswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _hhswitch;
}

-(void)switchAction:(HHSwitch *)sender
{
    if (sender.isOn)
    {
        NSLog(@"开始接单");
    }else
    {
        NSLog(@"接单已关");
        
    }
}

@end
