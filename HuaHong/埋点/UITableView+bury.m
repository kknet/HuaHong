//
//  UITableView+bury.m
//  HuaHong
//
//  Created by qk-huahong on 2019/7/17.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "UITableView+bury.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>

@implementation UITableView (bury)

+ (void)load
{
//     [self swizzleInstanceMethod:@selector(setDelegate:) swizzledSEL:@selector(swizzled_setDelegate:)];
    
    
}

- (void)swizzled_setDelegate:(id<UITableViewDelegate>)delegate
{
    if (delegate == nil) {
        return;
    }
    
    [self swizzled_setDelegate:delegate];
    
    SEL originalSEL = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzledSEL = @selector(swizzledTableView:didSelectRowAtIndexPath:);
    Method sel_Method = class_getInstanceMethod([self class], swizzledSEL);
    
    if (!class_respondsToSelector([delegate class], originalSEL)) { return; }
    
    BOOL addsuccess = class_addMethod([delegate class],
                                      swizzledSEL,
                                      method_getImplementation(sel_Method),
                                      method_getTypeEncoding(sel_Method));


    //如果添加成功了就直接交换实现， 如果没有添加成功，说明之前已经添加过并交换过实现了
    if (addsuccess) {
        Method originalMethod = class_getInstanceMethod([delegate class], originalSEL);
        Method swizzledMethod = class_getInstanceMethod([delegate class], swizzledSEL);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    

}

-(void)swizzledTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.key isEqualToString:@"123"]) {
        [MBProgressHUD showInfo:@"didSelectRowAtIndexPath方法被拦截" toView:nil];
        return;
    }
    
    
     [self swizzledTableView:tableView didSelectRowAtIndexPath:indexPath];
    
//    SEL swizzledSEL = @selector(swizzledTableView:didSelectRowAtIndexPath:);
//    if ([self respondsToSelector:swizzledSEL]) {
//        IMP imp = [self methodForSelector:swizzledSEL];
//        void (*func)(id, SEL,id,id) = (void *)imp;
//        func(self, swizzledSEL,tableView,indexPath);
//    }
    
    
}

////判断页面是否实现了某个sel
//- (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
//    unsigned int count;
//
//    Method *methodList = class_copyMethodList(class,&count);
//    for (int i = 0; i < count; i++) {
//        Method method = methodList[i];
//        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
//        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
//            return YES;
//        }
//    }
//    return NO;
//}


@end
