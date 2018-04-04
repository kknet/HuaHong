//
//  NSStri ng+IdentityCard.h
//  UUWorkplace
//
//  Created by 杨彬 on 15/1/25.
//  Copyright (c) 2015年 UU_Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    isChinese,
    isEnglish,
    isOther,
} CharType;

@interface NSString (IdentityCard)
//验证身份证
+ (BOOL)validateIDCardNumber:(NSString *)value;
//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;
//验证手机号
+ (BOOL)isValidatePhone:(NSString *)phone;
//校验护照
+ (BOOL)isValidPassport:(NSString *)value;
//校验邮编
+ (BOOL) isValidZipcode:(NSString*)value;

//判断是否是大小写及数字
+ (BOOL)isValiAa1:(NSString *)value;

//判断是否是中文或字母组成
+ (CharType)isChineseOrAa:(NSString *)value;

+ (BOOL)isWechat:(NSString *)value;

+(BOOL)isValidateName:(NSString *)name;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+(CGFloat)CalculateStringWidthWithString:(NSString *)string Height:(CGFloat)height Font:(UIFont *)font;

+(CGFloat)CalculateStringHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font;

/* !@brief **** 做微调---去掉左右空格  */
- (NSString *)doTrimming;

/* !@brief 186****5678 （号码中间隐藏）  */
- (NSString *)getFromNumber;

/* !@brief **** 做验证  */
- (BOOL)isEmpty;

-(NSString *)encodeString;
-(NSString *)decodeString;

@end
