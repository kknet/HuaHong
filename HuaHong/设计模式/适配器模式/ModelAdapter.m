//
//  ModelAdapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ModelAdapter.h"
#import "ItemModel.h"
#import "ContenModel.h"
//对象适配器
@implementation ModelAdapter

-(UIImage*)image{
    
    if ([self.data isMemberOfClass:[ContenModel class]]) {
        
        ContenModel *model =  self.data;
        
        return [UIImage imageNamed:model.imageName];
        
    }else{
        
        ItemModel *model =  self.data;
        
        return model.image;
        
    }
}

-(NSString*)contentStr{
    
    if ([self.data isMemberOfClass:[ContenModel class]]) {
        
        ContenModel *model =  self.data;
        
        return model.conntentStr;
        
    }else{
        
        ItemModel *model =  self.data;
        
        return model.conntentStr;
        
    }
}

@end
