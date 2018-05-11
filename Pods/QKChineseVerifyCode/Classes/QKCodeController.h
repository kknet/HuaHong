//
//  CodeController.h
//  Code
//
//  Created by Sunny on 24/4/18.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKCodeSelectedButton.h"

typedef void(^DismissSuceessBlock)(BOOL isSuccess);//是否登录成功

@interface QKCodeController : UIViewController{
    
}
@property(nonatomic,copy)DismissSuceessBlock dismissCallBack;

/** 实例化 codeController*/
+(instancetype)codeControllerWithDismissCallback:(DismissSuceessBlock)dismissCallBack;

@end
