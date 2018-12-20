//
//  StoryboardHomeController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "StoryboardHomeController.h"
@interface StoryboardHomeController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation StoryboardHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _textView.text = @"中国日报网10月24日电，10月25日至27日，日本首相安倍晋三时隔7年再次对中国进行正式访问，此次访问将有约500名日本商界领袖随安倍出访。此访正值《中日和平友好条约》缔结40周年重要节点，日本未来如何与中国相处引发日本媒体密切关注。中国日报网10月24日电，10月25日至27日，日本首相安倍晋三时隔7年再次对中国进行正式访问，此次访问将有约500名日本商界领袖随安倍出访。此访正值《中日和平友好条约》缔结40周年重要节点，日本未来如何与中国相处引发日本媒体密切关注。";
    
//    _textView
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
