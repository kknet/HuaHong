//
//  ContentModelAdeapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ContentModelAdeapter.h"
#import "ContenModel.h"
@implementation ContentModelAdeapter

-(UIImage*)image{
    
    ContenModel *model =  self.data;
    
    return [UIImage imageNamed:model.imageName];
}

-(NSString*)contentStr{
    ContenModel *model =  self.data;
    
    return model.conntentStr;
    
}


@end
