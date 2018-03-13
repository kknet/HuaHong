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

-(void)messageSend
{
//    Person *p = [[Person alloc]init];
    
//    NSClassFromString(<#NSString * _Nonnull aClassName#>)
    
    
   Person *p = objc_msgSend(objc_getClass("Person"),sel_registerName("alloc"));
    p = objc_msgSend(p, sel_registerName("init"));
    
//   objc_msgSend(p, sel_registerName("eatWith:"),@"汉堡");
    
    //调用父类方法
    struct objc_super hhsuper = {p,class_getSuperclass(objc_getClass("Person"))};
//    objc_msgSendSuper(&hhsuper, @selector(eatWith:),@"");

}
@end
