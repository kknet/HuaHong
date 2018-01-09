//
//  LoadingViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "LoadingViewController.h"
#import "LoadingHUD.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self startAnimation];

}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//}
-(void)startAnimation
{
    LoadingHUD *hud = [[LoadingHUD alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    hud.center = self.view.center;
    [self.view addSubview:hud];
    hud.progress = 0.8;
    
    [hud setPlayOrSuspendHandler:^(BOOL isPlay) {
        
        if (isPlay) {
            NSLog(@"sart");
            
        }else
        {
            NSLog(@"stop");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
