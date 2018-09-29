//
//  Presenter.m
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "Presenter.h"

@implementation Presenter

- (void)printTask
{
    [_mvpView printOnView:_model.content];
}

- (void)viewCilcked
{
    _model.content = [NSString stringWithFormat:@" line %d",arc4random()%100];
  [_mvpView printOnView:_model.content];
}
@end
