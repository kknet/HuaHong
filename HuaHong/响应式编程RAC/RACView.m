//
//  RACView.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/25.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "RACView.h"

@implementation RACView

//-(RACSubject *)subject
//{
//    if (_subject == nil) {
//        _subject = [RACSubject subject];
//    }
//    
//    return _subject;
//}
- (IBAction)btnClick:(UIButton *)sender
{
    [self.subject sendNext:@"instead of delegate method"];
    
}


@end
