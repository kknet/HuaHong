//
//  BaseModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    if ([key isEqualToString:@"id"])
//    {
//        self.kid = value;
//    }
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    //拿到成员变量列表
    Ivar *list = class_copyIvarList(self.class, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = list[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    
    free(list);
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        unsigned int count = 0;
        Ivar *list = class_copyIvarList(self.class, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = list[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            
            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
    }
    
    return self;
}

@end
