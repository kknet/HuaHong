//
//  MVVM_ViewModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVVM_ViewModel : NSObject

@property (nonatomic,strong,readonly)RACCommand *command;
@property (nonatomic,assign) BOOL isNeedRefresh;


@end
