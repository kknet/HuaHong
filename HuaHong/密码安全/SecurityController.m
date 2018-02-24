//
//  SecurityController.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "SecurityController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <SSKeychain.h>
#import "NSString+Hash.h"
#import "EncryptionTools.h"
#import "RSAEncryptor.h"
#import "RSACryptor.h"//CC

@interface SecurityController ()

@end

@implementation SecurityController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchIdentifier];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self encrypt_AES_DES];
}


#pragma mark - 指纹识别
-(void)touchIdentifier
{
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        NSLog(@"该系统版本不支持指纹识别");
        return;
    }
    
    //判断能否使用
    LAContext *context = [[LAContext alloc]init];
    
    //验证指纹识别是否可用
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        NSLog(@"指纹识别不可用");
        return;
    }
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"指纹验证成功" preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                
                [self presentViewController:alert animated:YES completion:nil];
                
            });
            
        }
            
        if (error){
            
            /*
             LAErrorAuthenticationFailed - 指纹无法识别
             LAErrorUserCancel     --用户点击了取消
             LAErrorUserFallback   --用户点击了输入密码
             LAErrorSystemCancel   --系统取消
             LAErrorPasscodeNotSet --因为你设备上没有设置密码
             LAErrorTouchIDNotAvailable  --设备没有Touch ID
             LAErrorTouchIDNotEnrolled   --因为你的用户没有输入指纹
             LAErrorTouchIDLockout --多次输入，密码锁定
             LAErrorAppCancel--    比如电话进入，用户不可控的
             */
            NSLog(@"error:%@",error);
        }
        
    }];
    
    

}


#pragma mark - MD5+HMAC
-(NSString *)getPassword:(NSString *)pwd
{
    //  1  一个字符串token  md5计算
    NSString *md5Token = [@"token" md5String];
    
    //  2  把原密码和之前生成的md5值再进行hmac加密
    NSString *hmacStr = [pwd hmacMD5StringWithKey:md5Token];
    
    //  3  从服务器获取当前时间 到分钟
    NSString *serviceTime = @"2018-02-24 11:22";
    
    // 4   第二步产生的hmac值+时间 和 第一步产生的md5值进行hmac加密
    return [[hmacStr stringByAppendingString:serviceTime] hmacMD5StringWithKey:md5Token];
}


#pragma mark - 钥匙串
/**
 * 设置钥匙串
 */
-(void)setKeyChain
{
   [SSKeychain setPassword:@"huahong123" forService:[NSBundle mainBundle].bundleIdentifier account:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]];
}

/**
 * 获取钥匙串
 */
- (void)getKeyChain {
    NSString *keychainPwd = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"]];
    if (keychainPwd) {
        NSLog(@"keychainPwd:%@",keychainPwd);
    }
}

#pragma mark - 对称加码
-(void)encrypt_AES_DES
{
    /**
     * EBC :独立加密 IV = nil
     * CBC :密码块链 IV
     */
    
    /** 区别:
     *  [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;
     *  [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmAES;
     */
    
    NSString *key = @"CC";
    
    //iv 向量
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];

    
    /**
     * AES - ECB
     */
    //加密
    NSString *reslut =  [[EncryptionTools sharedEncryptionTools]encryptString:@"hello" keyString:key iv:nil];
    NSLog(@"AES_ECB加密：%@",reslut);
    
    //解密
    NSString *decryptString = [[EncryptionTools sharedEncryptionTools]decryptString:@"Y/sCmKUMJsN9NUUahvxCqA==" keyString:key iv:nil];
    NSLog(@"AES_ECB解密：%@",decryptString);
    
    
    
    /**
     * AES - CBC
     */
    //加密
    NSString *CBC_EncryptString = [[EncryptionTools sharedEncryptionTools]encryptString:@"CCSmile" keyString:key iv:ivData];
    NSLog(@"AES_CBC加密字符串 %@",CBC_EncryptString);
    
    //解密
    NSString *CBC_DecryptString = [[EncryptionTools sharedEncryptionTools]decryptString:@"QoLihjsqqyc8jEozMvJdcQ==" keyString:key iv:ivData];
    NSLog(@"AES_CBC解密字符串 %@",CBC_DecryptString);
    
    /**
     * DES - ECB
     */
    
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;

    //加密
    NSString *DES_ECB_EncryptString =  [[EncryptionTools sharedEncryptionTools]encryptString:@"hello" keyString:key iv:nil];
    NSLog(@"DES_ECB加密字符串 %@",DES_ECB_EncryptString);
    
    //解密
    NSString *ECB_CBC_DecryptString = [[EncryptionTools sharedEncryptionTools]decryptString:@"DHq5763/Eq4=" keyString:key iv:nil];
    NSLog(@"DES_ECB解密字符串 %@",ECB_CBC_DecryptString);
    
    
    /**
     * DES - CBC
     */
    //加密
    NSString *DESCBC_EncryptString = [[EncryptionTools sharedEncryptionTools]encryptString:@"CCSmile" keyString:key iv:ivData];
    NSLog(@"DES_CBC加密字符串 %@",DESCBC_EncryptString);
    
    //解密
    NSString *DES_CBC_DecryptString = [[EncryptionTools sharedEncryptionTools]decryptString:@"gzlL3le9hmw=" keyString:key iv:ivData];
    NSLog(@"DES_CBC解密字符串 %@",DES_CBC_DecryptString);
}
#pragma mark - 非对称加码
-(void)encrypt_RSA
{
    //加密
    NSString *encodeStr = [RSAEncryptor encryptString:@"hello" publicKey:@"publicKey"];
    
    //解密
    NSString *decodeStr = [RSAEncryptor decryptString:@"" privateKey:@"privateKey"];
}
-(void)encrypt_RSA2
{
    //1.获取公钥
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"rsacert.der" ofType:nil];
    
    [[RSACryptor sharedRSACryptor]loadPublicKey:filePath];
    
    //2.加载私钥 ，P12文件
    NSString *p12FilePath = [[NSBundle mainBundle]pathForResource:@"p.p12" ofType:nil];
    
    //password:生成p12文件时设置的密码
    [[RSACryptor sharedRSACryptor]loadPrivateKey:p12FilePath password:@"123456"];
    
    NSData *result = [[RSACryptor sharedRSACryptor]encryptData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //base64
    NSString *base64 = [result base64EncodedDataWithOptions:0];
    
    NSLog(@"%@",base64);
    
    
    
    //解密
    NSData *D_data = [[RSACryptor sharedRSACryptor]decryptData:result];
    
    NSString *DString = [[NSString  alloc]initWithData:D_data encoding:NSUTF8StringEncoding];
    
    NSLog(@"解密的信息%@",DString);
    
    
    /*
     RSA + AES 组合（非对称 + 对称组合）
     1.利用AES对称 对数据本身加密
     2.RSA非对称算法，对AES的KEY加密
     
     */
}
@end
