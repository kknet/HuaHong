//
//  DesUtil.m
//  itvApp
//
//  Created by 达 on 2017/7/20.
//  Copyright © 2017年 达. All rights reserved.
//

#import "DesUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DesUtil

+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key andiv:(NSString *)iv
{
    //这个iv 是DES加密的初始化向量，可以用和密钥一样的MD5字符
    NSData * date = [iv dataUsingEncoding:NSUTF8StringEncoding];
    NSString *ciphertext = nil;
    NSUInteger dataLength = [clearText length];
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    
    
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,//加密模式 kCCDecrypt 代表解密
                                          kCCAlgorithmDES,//加密方式
                                          kCCOptionPKCS7Padding,//填充算法
                                          [key UTF8String], //密钥字符串
                                          kCCKeySizeDES,//加密位数
                                          [date bytes],//初始化向量
                                          [textData bytes]  ,
                                          dataLength,
                                          buffer, 2048,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        Byte* bb = (Byte*)[data bytes];
        
        ciphertext = [self parseByte2HexString:bb];
        
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSData *)plainData key:(NSString *)key
{
    
    NSString *cleartext = nil;
    NSUInteger dataLength = [plainData length];
    //    unsigned char buffer[1024];
    unsigned char buffer[2048];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,  //iv
                                          [plainData bytes]  , dataLength,
                                          buffer, 2048,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES解密成功");
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }else{
        NSLog(@"DES解密失败");
    }
    return cleartext;
}

//2进制 转 16进制
+(NSString *) parseByte2HexString:(Byte *) bytes

{
    
    NSMutableString *hexStr = [[NSMutableString alloc]init];
    
    int i = 0;
    
    if(bytes)
        
    {
        
        while (bytes[i] != '\0')
            
        {
            
            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
            if([hexByte length]==1)
                
                [hexStr appendFormat:@"0%@", hexByte];
            
            else
                
                [hexStr appendFormat:@"%@", hexByte];
            
            
            
            i++;
            
        }
        
    }
    
    NSLog(@"bytes 的16进制数为:%@",hexStr);
    
    return hexStr;
}

+ (NSData *)hex2data:(NSString *)hex {
    NSMutableData *data = [NSMutableData dataWithCapacity:hex.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < hex.length / 2; i++) {
        byte_chars[0] = [hex characterAtIndex:i*2];
        byte_chars[1] = [hex characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
    
}

@end
