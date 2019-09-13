//
//  AddVideoController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/9.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AppendVideoController.h"
#import "HHVideoManager.h"
@interface AppendVideoController ()

@end

@implementation AppendVideoController

-(BOOL)navigationShouldPopOnBackButton
{
    NSLog(@"back");
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音视频拼接";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"%s",__func__);
    
}
- (IBAction)addVideo:(id)sender
{
    
    NSURL *firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"]];
    NSURL *secondUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"weixinY" ofType:@"mp4"]];
    
    [HHVideoManager addFirstVideo:firstUrl andSecondVideo:secondUrl withMusic:nil];
}
- (IBAction)addVideoAndMusic:(id)sender
{
    NSURL *firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"]];
    NSURL *secondUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"weixinY" ofType:@"mp4"]];
    NSURL *musicUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"]];
    [HHVideoManager addFirstVideo:firstUrl andSecondVideo:secondUrl withMusic:musicUrl];
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
