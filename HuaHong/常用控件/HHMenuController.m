//
//  HHMenuController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/30.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHMenuController.h"

@interface HHMenuController ()

@end

@implementation HHMenuController
{
    UIMenuController *menuController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self createMenuController];
//    [self performSelector:@selector(myCopy)];
}
- (void)createMenuController
{
    menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:self.view.bounds inView:self.view];
    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(myCopy)];
    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(myCut)];
    UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(myPaste)];
    
    [menuController setMenuItems:@[item1,item2,item3]];
    [menuController setArrowDirection:UIMenuControllerArrowDown];
    [menuController setMenuVisible:YES animated:YES];

}

- (void)myCopy
{
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = @"hhhh";
    NSLog(@"copy");
}

- (void)myCut
{
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = @"hhhh";
    self.title = nil;
    NSLog(@"cut");

    

}

- (void)myPaste
{
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    self.title = paste.string;
    NSLog(@"paste");

}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(myCopy) || action == @selector(myCut) || action == @selector(myPaste))
    {
        return YES;
    }
    
    return NO;
}
@end
