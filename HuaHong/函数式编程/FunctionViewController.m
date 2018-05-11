//
//  FunctionViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "FunctionViewController.h"
#import <objc/message.h>
#import "Person.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
}

//函数式编程
-(void)funtion
{
    Person *p = [Person new];
    
    NSString *name = [p initWithBlock:^NSString *(NSString *firstName, NSString *lastName) {
        return [firstName stringByAppendingString:lastName];
    }].fullName;
    
    NSLog(@"nsme:%@",name);
}


@end
