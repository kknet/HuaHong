//
//  BlockViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BlockVC.h"

@implementation BlockVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

-(void)getURLWithString:(NSString *)string block:(id (^)(id obj))block
{
    block(@"hh");
}

//- (void)demo1 {
//
//    id(^block1)() = ^id() {
//
//        return nil;
//    };
//
//    <#returnType#>(^<#blockName#>)(<#parameterTypes#>) = ^(<#parameters#>) {
//        <#statements#>
//    };
//}



@end
