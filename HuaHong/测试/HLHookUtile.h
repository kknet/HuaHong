//
//  HLHookUtile.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/2.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLHookUtile : NSObject


/**
 方法互换
 
 @param cls 需要互换的类
 @param originalSEL 原始方法
 @param swizzledSEL 要换成的方法
 */
+(void)hookClass:(Class)cls andOriginalSEL:(SEL)originalSEL andSwizzledSEL:(SEL)swizzledSEL;





@end


NS_ASSUME_NONNULL_END
