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

@property (nonatomic,strong) Person *persion;

@end

@implementation runtimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.persion = [Person new];
    self.persion.fullName = @"华宏";
    
    [self changeVarValue];
    
    NSLog(@"%@",self.persion.fullName);
    
    
    //添加方法测试
    [self addMethod];
    [self.persion performSelector:@selector(missMethod:) withObject:@"蛋糕"];
}

#pragma mark - 消息发送机制
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

#pragma mark - 方法欺骗
-(void)hook
{
    //详见 NSURL+hook.m
    [NSURL URLWithString:@"华宏"];
    
}

/*
+(void)load
{
    //获取类方法
    Method URLWithStr = class_getClassMethod(self, @selector(URLWithString:));
    Method HHURLWithStr = class_getClassMethod(self, @selector(HHURLWithString:));
    
    method_exchangeImplementations(URLWithStr, HHURLWithStr);
    
    //获取实例方法
//  Method method =  class_getInstanceMethod([self.persion class], @selector(eatWith:));
    
}
+(instancetype)HHURLWithString:(NSString *)string
{
    NSURL *url = [NSURL HHURLWithString:string];
    if (url == nil) {
        NSLog(@"------------URL == nil------------");
    }
    
    return url;
}

*/

#pragma mark - 动态添加方法

//添加方法1
-(void)addMethod
{
    class_addMethod([self.persion class], @selector(missMethod:), (IMP)hheat, "v@:@");
}

void hheat(id obj,SEL sel,NSString *objc)
{
    NSLog(@"吃到了:%@",objc);
}

//添加方法2

//+(BOOL)resolveClassMethod:(SEL)sel
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    
    //如果下面未动态绑定该方法，则会消息重定向： -(id)forwardingTargetForSelector:(SEL)aSelector
//    if (sel == @selector(eat:)) {
//
//        //"v@:@" v代表void，@代表id类型，:代表SEL
//        class_addMethod(self, sel, (IMP)hheat, "v@:@");
//
//        return YES;
//    }
    
    return [super resolveInstanceMethod:sel];
}




// 消息重定向
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    //eat:方法在本类未实现，交给Person类来实现，方法名必须一致，因为内部kvc实现
    //若未指定实现类，则执行方法签名： -(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//    return [Person new];
    
    return [super forwardingTargetForSelector:aSelector];
}

// 方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString *selString = NSStringFromSelector(aSelector);
    if ([selString isEqualToString:@"eat:"]) {
        
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
        //拿到方法签名后接下来会执行消息派发：-(void)forwardInvocation:(NSInvocation *)anInvocation
    }else
    {
      return  [super methodSignatureForSelector:aSelector];
    }
}

// 消息派发
-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    
    //转发
    Person *p = [Person new];
    if ([p respondsToSelector:selector]) {
        
        [anInvocation invokeWithTarget:p];
    }else
    {
        [super forwardInvocation:anInvocation];
    }
}

//方法异常
-(void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSString *selStr = NSStringFromSelector(aSelector);
    
    NSLog(@"%@ 方法异常",selStr);
}

#pragma mark - 改变变量的值
-(void)changeVarValue
{
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([self.persion class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar var = ivar[i];
        
        const char *varName = ivar_getName(var);
        
        NSString *name = [NSString stringWithUTF8String:varName];
        
        if ([name isEqualToString:@"_fullName"]) {
            
            object_setIvar(self.persion, var, @"huahong");
            
            break;
        }
    }
}

#pragma mark - 添加属性 UIScrollView+Refresh.m
/*
static const char *key = "key";

-(NSString *)name
{
    //&key 经测试，加不加&都可以
    return objc_getAssociatedObject(self, key);
 
}

-(void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 
 */
@end