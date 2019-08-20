//
//  MVVM_Model.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/11.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVVM_ModelDelegate <NSObject>
@optional
- (void)setModel:(id)model;
@end


@interface MVVM_Model : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDictionary *images;

@end
