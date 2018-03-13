//
//  runtimeViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/4.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "runtimeViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "NSURL+hook.h"

@interface runtimeViewController ()

@end

@implementation runtimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

//方法欺骗
-(void)hook
{
    //详见"NSURL+hook.h"
    [NSURL URLWithString:@"华宏"];
}

//消息发送机制
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

//动态添加方法
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    class_addMethod(self, sel, (IMP)hheat, "v@:@");
    return [super resolveInstanceMethod:sel];
}

void hheat(id obj,SEL sel,NSString *objc)
{
    NSLog(@"吃到了:%@",objc);
}
@end
