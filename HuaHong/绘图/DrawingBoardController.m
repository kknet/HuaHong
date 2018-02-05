//
//  DrawingBoardController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/1.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DrawingBoardController.h"
#import "DrawBoardView.h"
@interface DrawingBoardController ()
@property (strong, nonatomic) IBOutlet DrawBoardView *boardView;
@property (strong, nonatomic) IBOutlet UISlider *slider;


@end

@implementation DrawingBoardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sliderAction:self.slider];
    
}
- (IBAction)sliderAction:(UISlider *)sender
{
    self.boardView.lineWidth = sender.value;
}

- (IBAction)clear:(id)sender
{
    [self.boardView clear];
}
- (IBAction)back:(id)sender
{
    [self.boardView back];

}
- (IBAction)xiangpi:(id)sender
{
    [self.boardView xiangpi];

}
- (IBAction)save:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.boardView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.boardView.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

- (IBAction)changeColor:(UIButton *)sender
{
    self.boardView.lineColor = sender.backgroundColor;
}

@end
