//
//  BlockViewController.h
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockViewController : UIViewController

-(void)getURLWithString:(NSString *)string block:(id(^)(id obj))block;
@end
