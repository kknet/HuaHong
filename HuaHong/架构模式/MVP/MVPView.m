//
//  MVPView.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MVPView.h"

@implementation MVPView

-(instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapAction)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

- (void)viewTapAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(viewCilcked)]) {
        
        [_delegate viewCilcked];
    }
}

- (void)printOnView:(NSString *)content
{
    NSLog(@"printOnView:%@",content);
}
@end
