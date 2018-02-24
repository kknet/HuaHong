//
//  RSAEncryptor.h
//  HuaHong
//
//  Created by 华宏 on 2018/2/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface RSAEncryptor : NSObject

/**
 *  加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 *  解密方法
 *
 *  @param str     需要解密的字符串
 *  @param privKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
@end

