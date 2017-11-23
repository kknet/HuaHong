//
//  DesUtil.h
//  itvApp
//
//  Created by 达 on 2017/7/20.
//  Copyright © 2017年 达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject


+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key andiv:(NSString *)iv;
+(NSString *) decryptUseDES:(NSData *)plainData key:(NSString *)key;


+ (NSData *)hex2data:(NSString *)hex;
@end
