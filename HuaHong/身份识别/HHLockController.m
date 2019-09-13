//
//  HHLockController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/22.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHLockController.h"
#import "HHLockView.h"
@interface HHLockController ()

@end

@implementation HHLockController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blueColor;
    
    HHLockView *lockView = [HHLockView new];
    [self.view addSubview:lockView];
    
    [lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(300);
        make.center.mas_equalTo(lockView.superview);
    }];
    
    lockView.center = self.view.center;
    
    [lockView setLockBlock:^BOOL(NSString *pwd) {
        
        return [pwd isEqualToString:@"1235789"]?YES:NO;
    }];
}

@end
