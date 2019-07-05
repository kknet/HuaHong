//
//  NSDictionary+CrashHandle.m
//  RequestDemo
//
//  Created by huafeng on 2019/3/15.
//  Copyright © 2019年 雷雷. All rights reserved.
//

#import "NSDictionary+CrashHandle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (BOOL)gl_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)gl_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) gl_swizzleMethod:origSel withMethod:altSel];
}

@end

@implementation NSDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self gl_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(gl_initWithObjects:forKeys:count:)];
        [self gl_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(gl_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)gl_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)gl_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self gl_initWithObjects:safeObjects forKeys:safeKeys count:j];
}


@end

@implementation NSMutableDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class gl_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(gl_setObject:forKey:)];
        [class gl_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(gl_setObject:forKeyedSubscript:)];
    });
}

- (void)gl_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
        return;
    }
    [self gl_setObject:anObject forKey:aKey];
}

- (void)gl_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key || !obj) {
        return;
    }
    [self gl_setObject:obj forKeyedSubscript:key];
}

@end

@implementation NSArray (NilSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArrayI");
        [class gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(gl_objectAtIndex:)];
    });
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)gl_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count < index) {
        @try {
            return [self gl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self gl_objectAtIndex:index];
    }
}

@end

@implementation NSMutableArray (NilSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArrayM");
        [class gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(gl_objectAtIndex:)];
    });
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)gl_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count < index) {
        @try {
            return [self gl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self gl_objectAtIndex:index];
    }
}

@end

@implementation NSArray (SingleNilSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSSingleObjectArrayI");
        [class gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(gl_objectAtIndex:)];
    });
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)gl_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count < index) {
        @try {
            return [self gl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self gl_objectAtIndex:index];
    }
}

@end

@implementation NSArray (PlaceholderNilSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSArray0");
        [class gl_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(gl_objectAtIndex:)];
    });
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)gl_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count <= index) {
        @try {
            return [self gl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self gl_objectAtIndex:index];
    }
}

@end

@implementation NSNull (NilSafe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self gl_swizzleMethod:@selector(methodSignatureForSelector:) withMethod:@selector(gl_methodSignatureForSelector:)];
        [self gl_swizzleMethod:@selector(forwardInvocation:) withMethod:@selector(gl_forwardInvocation:)];
    });
}

- (NSMethodSignature *)gl_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self gl_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)gl_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}

@end
