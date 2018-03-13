//
//  XMLModel.m
//  HuaHong
//
//  Created by 华宏 on 2018/2/20.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "XMLModel.h"

@implementation XMLModel
{
    NSString *author;
}
-(NSString *)time
{
    
    int len = self.length.intValue;
    
    //时分秒
    return [NSString stringWithFormat:@"%02d:%02d:%02d",len/3600,(len%3600)/60,(len%60)];
    
}


+(instancetype)videoWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
    
}



-(NSString *)description
{
    
    return [NSString stringWithFormat:@"%@{videoID:%@,name:%@,length:%@,videoURL:%@,imageURL:%@,desc:%@,teacher:%@}",[super description],self.videoId,self.name,self.length,self.videoURL,self.imageURL,self.desc,self.teacher];
    
    
}
@end
