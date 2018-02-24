//
//  XMLModel.h
//  HuaHong
//
//  Created by 华宏 on 2018/2/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLModel : NSObject

@property(nonatomic,strong)NSNumber *videoId;
@property(nonatomic,copy)NSString  *name;
@property(nonatomic,strong)NSNumber *length;
@property(nonatomic,strong)NSString  *videoURL;
@property(nonatomic,strong)NSString *imageURL;
@property(nonatomic,strong)NSString  *desc;
@property(nonatomic,strong)NSString *teacher;
@property(nonatomic,readonly)NSString *time;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)videoWithDict:(NSDictionary *)dict;

@end
