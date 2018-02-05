//
//  DrawBoardView.h
//  HuaHong
//
//  Created by 华宏 on 2018/2/5.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawBoardView : UIView

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineWidth;

-(void)clear;
-(void)back;
-(void)xiangpi;

@end
