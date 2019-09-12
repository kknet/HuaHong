//
//  NSString+null.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "NSString+null.h"

@implementation NSString (null)
+ (void)load
{
    [self swizzleClassMethod:@selector(stringWithFormat:) swizzledSEL:@selector(swizzle_stringWithFormat:)];
    
    [self swizzleInstanceMethod:@selector(stringByAppendingString:) swizzledSEL:@selector(swizzle_stringByAppendingString:)];
}

+ (instancetype)swizzle_stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
   
    va_list argList;
    va_start(argList, format);
    
//  不要把变量参数遍历出来,会崩溃
//    if(format) {
//        [arrayM addObject:format];
//        //临时指针变量
//        id temp;
//        while((temp = va_arg(argList, id))) {
//            [arrayM addObject:temp];
////            NSLog(@"%@",arrayM);
//        }
//    }

    NSString *result = [[NSString alloc]initWithFormat:format arguments:argList];
    result = [result stringByReplacingOccurrencesOfString:@"(null)" withString:@""];

    va_end(argList);
    
    return result;
}

- (NSString *)swizzle_stringByAppendingString:(NSString *)aString
{
    return [self swizzle_stringByAppendingString:aString?:@""];
}
@end
