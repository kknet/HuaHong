//
//  MVVM_Model.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface MVVM_Model : BaseModel

@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;

+ (id)InfoWithDictionary:(NSDictionary *)dic;

@end
