//
//  BuryViewController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "BuryViewController.h"
#import "NSObject+bury.h"
#import "UIControl+bury.h"
#import "UIGestureRecognizer+bury.h"

@interface BuryViewController ()

@property (nonatomic,strong) UIButton     *button;
@property (nonatomic,strong) UILabel      *label;
@property (nonatomic,strong) UITableView  *tableView;

@end

@implementation BuryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"埋点";
    
    [self setUpUI];
}

- (void)setUpUI
{
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.button];
    [self.button setTitle:@"button" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [UIColor cyanColor];
    self.button.key = @"123";
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    
    self.label = [[UILabel alloc]init];
    [self.view addSubview:self.label];
    self.label.text = @"手势";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = UIColor.orangeColor;
    self.label.userInteractionEnabled = YES;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_button.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.key = @"123";
    [self.label addGestureRecognizer:tap];
}

- (void)buttonAction:(UIButton *)sender
{
    NSLog(@"button被点击了");
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"手势被点击了");
}

@end
