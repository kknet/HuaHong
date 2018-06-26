//
//  ViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatButton];
    
    
    
}

- (void)creatButton
{
    UIImage *image = [UIImage imageNamed:@"flash"];

    CGFloat space = 5;// 图片和文字的间距
    NSString *title = @"测试测试测试";
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat  titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    CGFloat  titleHeight = [title sizeWithAttributes:@{NSFontAttributeName:font}].height;
    
    CGFloat btnWidth = 200;
    
    //    为了防止文字内容过多
    if (titleWidth > btnWidth - image.size.width - space) {
        titleWidth = btnWidth - image.size.width - space;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, btnWidth, 100);
    button.backgroundColor = [UIColor cyanColor];
    button.titleLabel.font = font;
    [self.view addSubview:button];
    button.center = self.view.center;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    //文字在左，图片在右
    //    文字向左边调整
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -(image.size.width + space*0.5), 0, (image.size.width + space*0.5))];
    
    //    图片向右边调整
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //图片在上,文字在下
    [button setTitleEdgeInsets:UIEdgeInsetsMake((titleHeight*0.5 + space*0.5), -image.size.width*0.5, -(titleHeight*0.5 + space*0.5), image.size.width*0.5)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(-(image.size.height*0.5 + space*0.5), titleWidth*0.5, (image.size.height*0.5 + space*0.5), -titleWidth*0.5)];
}

-(void)imageStretch
{
    UIImage *image = [UIImage imageNamed:@"flash"];
    
    //这个函数是UIImage的一个实例函数，它的功能是创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个是上面不拉伸的高度。
    image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    //将图片显示出来
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 100, 50)];
    imageView.image = image;
    [self.view addSubview:imageView];
}
@end
