//
//  UITableView+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "UITableView+bury.h"
#import <objc/runtime.h>

@implementation UITableView (bury)

+ (void)load
{
     [self swizzleInstanceMethod:@selector(setDelegate:) swizzledSEL:@selector(swizzled_setDelegate:)];
}

- (void)swizzled_setDelegate:(id<UITableViewDelegate>)delegate
{
    
    [self swizzled_setDelegate:delegate];
    
    SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
    if (![self isContainSel:sel inClass:[delegate class]]) {
        
        return;
    }
    
    NSLog(@"cell点击%@",[NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([delegate class]), NSStringFromClass([self class]),self.tag]);
    SEL sel_ =  NSSelectorFromString([NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([delegate class]), NSStringFromClass([self class]),self.tag]);
    BOOL addsuccess = class_addMethod([delegate class],
                                      sel_,
                                      method_getImplementation(class_getInstanceMethod([self class], @selector(swizzledTableView:didSelectRowAtIndexPath:))),
                                      nil);
    
    //如果添加成功了就直接交换实现， 如果没有添加成功，说明之前已经添加过并交换过实现了
    if (addsuccess) {
        Method selMethod = class_getInstanceMethod([delegate class], sel);
        Method sel_Method = class_getInstanceMethod([delegate class], sel_);
        method_exchangeImplementations(selMethod, sel_Method);
    }
    
}

-(void)swizzledTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.key isEqualToString:@"123"]) {
        
        NSLog(@"didSelectRowAtIndexPath方法被拦截");
        [MBProgressHUD showInfo:@"didSelectRowAtIndexPath方法被拦截" toView:nil];
        return;
    } else {
        
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@/%@/%ld", NSStringFromClass([self class]),  NSStringFromClass([tableView class]), tableView.tag]);
        if ([self respondsToSelector:sel]) {
            IMP imp = [self methodForSelector:sel];
            void (*func)(id, SEL,id,id) = (void *)imp;
            func(self, sel,tableView,indexPath);
        }
    }
}

//判断页面是否实现了某个sel
- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}


@end
