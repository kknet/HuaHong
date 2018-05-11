//
//  CustomTextField.h
//  HuaHong
//
//  Created by 华宏 on 2018/4/24.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseValidate.h"

@interface CustomTextField : UITextField

@property (nonatomic, strong) BaseValidate *inputValidate;

// 验证是否符合要求
- (BOOL)validate;

@end
