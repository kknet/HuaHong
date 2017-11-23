//
//  NSString+IdentityCard.m
//  UUWorkplace
//
//  Created by 杨彬 on 15/1/25.
//  Copyright (c) 2015年 UU_Organization. All rights reserved.
//

#import "NSString+IdentityCard.h"

@implementation NSString (IdentityCard)

// 校验身份证号码
+ (BOOL)validateIDCardNumber:(NSString *)value{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = [value length];
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            [value substringWithRange:NSMakeRange(6,2)];
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidateName:(NSString *)name{
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5]{1,100}";
    NSPredicate *nameRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [nameRegex evaluateWithObject:name];
}

//验证手机号
+ (BOOL)isValidatePhone:(NSString *)phone {
    NSString *reg = @"^1+[3456789]+\\d{9}";
    NSPredicate *regextestPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    if ([regextestPhone evaluateWithObject:phone]) {
        return YES;
    }
    return NO;
}

//校验护照
+ (BOOL)isValidPassport:(NSString *)value
{
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G')) {
        return NO;
    }
    if (first == 'P') {
        if (length != 8) {
            return NO;
        }
    }
    if (first == 'G') {
        if (length != 9) {
            return NO;
        }
    }
    
    BOOL result = YES;
    for (NSInteger i = 1; i < length; i++) {
        if (!(str[i] >= '0' && str[i] <= '9')) {
            result = NO;
            break;
        }
    }
    return result;
}
//校验邮编
+ (BOOL) isValidZipcode:(NSString*)value
{
    const char *cvalue = [value UTF8String];
    long len = strlen(cvalue);
    if (len != 6) {
        return FALSE;
    }
    for (int i = 0; i < len; i++)
    {
        if (!(cvalue[i] >= '0' && cvalue[i] <= '9'))
        {
            return FALSE;
        }
    }
    return TRUE;
}


//判断是否是大小写及数字
+ (BOOL)isValiAa1:(NSString *)value {
    NSString *regex = @"^(?:(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])|(?=.*[A-Z])(?=.*[a-z])(?=.*[^A-Za-z0-9])|(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9])|(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])).{6,}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:value] == YES) {
        return YES;
    } else {
        return NO;
    }
}

+ (CharType)isChineseOrAa:(NSString *)value {
    NSString *testString = value;
    
    NSUInteger alength = [testString length];
    
    CharType type = isChinese;
    
    for (int i = 0; i < alength; i++) {
        
        char commitChar = [testString characterAtIndex:i];
        
        NSString *temp = [testString substringWithRange:NSMakeRange(i,1)];
        
        const char *u8Temp = [temp UTF8String];
        
        if (3==strlen(u8Temp)){
            
            //NSLog(@"字符串中含有中文");
            type = isChinese;
            break;
        }else if((commitChar>64)&&(commitChar<91)){
            
            //NSLog(@"字符串中含有大写英文字母");
            type = isEnglish;
            break;
        }else if((commitChar>96)&&(commitChar<123)){
            
            //NSLog(@"字符串中含有小写英文字母");
            type = isEnglish;
            break;
            
        }else{
            
            //NSLog(@"字符串中含有非法字符");
            type = isOther;
            break;
        }
        
    }
    return type;
}
+ (BOOL)isWechat:(NSString *)value{
    NSString *regex = @"^[a-zA-Z][a-zA-Z0-9_-]{5,19}$";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:value] == YES) {
        return YES;
    } else {
        return NO;
    }
}

//判断是否是系统表情

+ (BOOL)stringContainsEmoji:(NSString *)string

{
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     
     {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff)
             
         {
             
             if (substring.length > 1)
                 
             {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                     
                 {
                     
                     returnValue = YES;
                 }
                 
             }
             
         }
         
         else if (substring.length > 1)
             
         {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
         }
         else
             
         {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (0x2B05 <= hs && hs <= 0x2b07)
                 
             {
                 
                 returnValue = YES;
                 
             }
             else if (0x2934 <= hs && hs <= 0x2935)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (0x3297 <= hs && hs <= 0x3299)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                 
             {
                 
                 returnValue = YES;
             }
             
         }
         
     }];
    
    return returnValue;
    
}

+(CGFloat)CalculateStringWidthWithString:(NSString *)string Height:(CGFloat)height Font:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.width;
}

+(CGFloat)CalculateStringHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.height;
}

/* !@brief **** 做微调---去掉左右空格  */
/*
 NSString *temptext = [messageTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
 NSString *text = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
 第1行是去除2端的空格
 第2行是去除回车
 */
- (NSString *)doTrimming{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
}

/* !@brief 186****5678 （手机号码中间隐藏4位）  */
- (NSString *)getFromNumber{
    if (self.length > 7) {
        NSString *resultStr = self;
        NSString *firtStr = [self substringToIndex:3];
        NSString *lastStr = [self substringFromIndex:self.length - 4];
        resultStr = [NSString stringWithFormat:@"%@****%@",firtStr,lastStr];
        
        return resultStr;
    }
    return self;
}

/* !@brief **** 对字符串进行验证 是否存在，不存在返回“”  */
- (BOOL)isEmpty{
    if (self && self.length >0) {
        return NO;
    }
    return YES;
}
@end
