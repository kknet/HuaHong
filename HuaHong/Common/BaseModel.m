//
//  BaseModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/3.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <YYModel.h>

@implementation BaseModel

+ (instancetype)parserModelWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [self yy_modelWithDictionary:dictionary];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
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

//MARK:- NSCoding
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
        
         free(list);
    }
    
    return self;
}

//MARK: - 自动化归解档
// 模型转字典
- (NSDictionary *)modelToDictionay
{
    unsigned int count = 0;
    Ivar *list = class_copyIvarList(self.class, &count);
    
    if (count > 0) {
        
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];

       for (int i = 0; i < count; i++) {
           Ivar ivar = list[i];
           
           NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
           id value = [self valueForKey:key];
           
           if (key && value) {
                [dicM setObject:value forKey:key];
           }
          
       }
        
        return dicM.copy;
    }
   
    
    free(list);
    
    return nil;
}

- (NSDictionary *)modelToDictionay1
{
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(self.class, &count);
    if (count > 0) {
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
              
        const void *propertyName = property_getName(propertys[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        SEL sel = NSSelectorFromString(name);
        if (sel) {
            id value =  ((id (*) (id,SEL))objc_msgSend)(self, sel);
            if (value) {
                dicM[name] = value;
            }
        }
              
        }
        
        return dicM.copy;
    }
    
    free(propertys);
    return nil;
}

//字典转模型
- (instancetype)initWithDic:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        for (NSString *key in dict.allKeys) {
            id value = dict[key];
            SEL setter = [self setterMethod:key];
            if (setter) {
               ((void (*) (id,SEL,id))objc_msgSend)(self, setter,value);
            }
        }
        
    }
    
    return self;
}

- (SEL)setterMethod:(NSString *)key
{
    NSString *methodName = [NSString stringWithFormat:@"set:%@",key.capitalizedString];
    SEL setter = NSSelectorFromString(methodName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    
    return nil;
}

//MARK: - NSCopying,NSMutableCopying
- (id)copyWithZone:(NSZone *)zone
{
    BaseModel *model = [[[self class]allocWithZone:zone]init];
    model.userName = self.userName;
    
    //未公开的成员
    model->_age = _age;
//    [model setValue:_userID forKey:@"userID"];
    
    return model;
}


//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    BaseModel *model = [[[self class]allocWithZone:zone]init];
//    model.userName = self.userName;
//
//    //未公开的成员
//    model->_age = _age;
//    [model setValue:_userID forKey:@"userID"];
//
//    return model;
//}
@end
