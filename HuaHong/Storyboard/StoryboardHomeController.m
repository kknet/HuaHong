//
//  StoryboardHomeController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "StoryboardHomeController.h"
#import "LoginViewController.h"
@interface StoryboardHomeController ()

@end

@implementation StoryboardHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


- (IBAction)contactAction:(id)sender
{
    [self performSegueWithIdentifier:@"contact" sender:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LoginViewController *loginVC = segue.destinationViewController;
    loginVC.title = @"通讯录登录";
}


@end
