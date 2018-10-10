//
//  NSObject+KVO.m
//  HuaHong
//
//  Created by 华宏 on 2018/10/10.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

static const char *KVO_observer = "KVO_observer";
static const char *KVO_getter = "KVO_getter";
static const char *KVO_setter = "KVO_setter";
static const char *KVO_context = "KVO_context";

@implementation NSObject (KVO)

- (void)hhaddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    /*
     1、自定义一个子类
     2、重写setName方法，在方法中，调用super的通知观察者
     3、修改当前的isa指针，指向自定义的子类
     */
    
    //1.动态生成一个类
    //1.1获取类名
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"HHKVO_"stringByAppendingString:oldClassName];
    
    //创建一个类的class
//    const char newName = [newClassName UTF8String];
    Class myClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    
    //注册类
    objc_registerClassPair(myClass);
    
    //2.添加set方法
    //首先动态添加set方法，参数keypath就是get方法，通过它拼接处set方法（就是首字母大写，加:）
    NSString *keyPathChange = [[[keyPath substringToIndex:1]uppercaseString]stringByAppendingString:[keyPath substringFromIndex:1]];
    NSString *setNameStr = [NSString stringWithFormat:@"set%@:",keyPathChange];
    SEL setSEL = NSSelectorFromString(setNameStr);
    class_addMethod(myClass, setSEL, (IMP)setMethod, "v@:@");
    
    //3.修改isa指针
    object_setClass(self, myClass);
    
    //4.保存观察者对象
    objc_setAssociatedObject(self, KVO_observer, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //5.保存set、get方法名、context
    objc_setAssociatedObject(self, KVO_getter, keyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, KVO_setter, setNameStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    objc_setAssociatedObject(self, KVO_context, (__bridge id)(context), OBJC_ASSOCIATION_COPY_NONATOMIC);


    
    
}

void setMethod(id self,SEL _cmd,NSString *newValue)
{
    NSString *setNameStr = objc_getAssociatedObject(self, KVO_setter);
    NSString *getNameStr = objc_getAssociatedObject(self, KVO_getter);
    
    id context = objc_getAssociatedObject(self, KVO_context);

    
    //获取oldValue
    id oldValue = objc_msgSend(self, NSSelectorFromString(getNameStr));
    
    //保存子类型
    Class class = [self class];
    
    //改变self的isa指针
    object_setClass(self, class_getSuperclass(class));
    
    //调用的set方法
    objc_msgSend(self, NSSelectorFromString(setNameStr),newValue);
    
     //拿到观察者
    id observe = objc_getAssociatedObject(self, KVO_observer);
    
    NSMutableDictionary *change = [NSMutableDictionary dictionary];
    
    if (oldValue)
    {
        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
    }
    
    if (newValue)
    {
        [change setObject:newValue forKey:NSKeyValueChangeNewKey];
    }
    
    
    //通知观察者
    objc_msgSend(observe, @selector(observeValueForKeyPath:ofObject:change:context:),getNameStr,self,change,context);
    
    //改回子类类型
    object_setClass(self, class);
}
@end
