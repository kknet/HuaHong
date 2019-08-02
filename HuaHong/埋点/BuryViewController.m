//
//  BuryViewController.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/16.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "BuryViewController.h"
#import "UIControl+bury.h"
#import "UIGestureRecognizer+bury.h"

@interface BuryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton     *button;
@property (nonatomic,strong) UILabel      *label;
@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong) UITapGestureRecognizer *tap;

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
    _label.key = @"123";
    
    _tap = [[UITapGestureRecognizer alloc]init];
    _tap.key = @"123";
    [_tap addTarget:self action:@selector(tapAction:)];
    [self.label addGestureRecognizer:_tap];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 264, self.view.width, self.view.height-_label.bottom) style:UITableViewStylePlain];
    _tableView.key = @"123";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)buttonAction:(UIButton *)sender
{
    NSLog(@"button被点击了");
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"手势被点击了");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView");
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection");
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.key = @"123";
    
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld,------row:%ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    NSLog(@"didSelectRowAtIndexPath:%@",indexPath);
    [MBProgressHUD showInfo:@"didSelectRowAtIndexPath方法被点击" toView:nil];
}
@end
