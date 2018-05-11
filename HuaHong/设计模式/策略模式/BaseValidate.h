//
//  BaseValidate.h
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseValidate : NSObject

@property (nonatomic, strong) NSString *attributeInputStr;

- (BOOL)validateInputTextField:(UITextField *)textField;

@end
