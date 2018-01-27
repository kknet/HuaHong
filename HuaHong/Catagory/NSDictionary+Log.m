//
//  NSDictionary+Log.m
//  OC05-task-01
//
//  Created by keyzhang on 15-1-25.
//  Copyright (c) 2015年 keyzhang. All rights reserved.
//

#import "NSDictionary+Log.h"

@implementation NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"{\n"];
    //遍历数组
    for (id obj in self) {
        [strM appendFormat:@"\t%@ = %@,\n",obj, [self objectForKey:obj]];
    }
    
    [strM appendString:@"}"];
    
    return strM;
}

@end
