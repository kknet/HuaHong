//
//  TestView.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/28.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "TestView.h"

@implementation TestView

-(instancetype)init
{
    if ([super init])
    {
        self.backgroundColor = [UIColor cyanColor];

        NSLog(@"init");
        
    }
    
    return [super init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        NSLog(@"initWithFrame");


    }
    
    return self;
}
- (void)drawRect:(CGRect)rect
{
    NSString *str = @"此处手写签名: 正楷, 工整书写";

    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor (context,  199/255.0, 199/255.0,199/255.0, 1.0);//设置填充颜色
    [str drawInRect:CGRectMake((rect.size.width -200)/2, (rect.size.height -20)/3-5,200, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
   
}


//- (void)createMenuController
//{
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    [menuController setTargetRect:self.bounds inView:self];
//    [menuController setMenuVisible:YES animated:YES];
//    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(myCopy:)];
//    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"剪切" action:@selector(myCut:)];
//    UIMenuItem *item3 = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(myPaste:)];
//    
//    [menuController setMenuItems:@[item1,item2,item3]];
//    [menuController setArrowDirection:UIMenuControllerArrowDown];
//}
//
//- (void)myCopy:(UIMenuController *)menu
//{
//    NSLog(@"%s",__func__);
//    UIPasteboard *paste = [UIPasteboard generalPasteboard];
//    paste.string = @"hhhh";
//}
//
//- (void)myCut:(UIMenuController *)menu
//{
//    NSLog(@"%s",__func__);
//    UIPasteboard *paste = [UIPasteboard generalPasteboard];
//    paste.string = @"hhhh";
////    self.title = nil;
//    
//}
//
//- (void)myPaste:(UIMenuController *)menu
//{
//    NSLog(@"%s",__func__);
//    UIPasteboard *paste = [UIPasteboard generalPasteboard];
////    self.title = paste.string;
//    
//}
//
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (action == @selector(copy:) || action == @selector(cut:) || action == @selector(paste:) || action == @selector(myCopy:) || action == @selector(myCut:) || action == @selector(myPaste:))
//    {
//        
//        return YES;
//    }
//    
//    return NO;
//}
- (void)renderWithModel:(id)model
{
    NSLog(@"renderWithModel");
}
@end
