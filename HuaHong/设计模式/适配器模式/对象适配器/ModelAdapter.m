//
//  ModelAdapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ModelAdapter.h"
#import "TestModel.h"
#import "Model.h"
//对象适配器
@implementation ModelAdapter

-(UIImage*)image{
    
    if ([self.data isMemberOfClass:[Model class]]) {
        
        Model *model =  self.data;
        
        return [UIImage imageNamed:model.imageName];
        
    }else{
        
        TestModel *model =  self.data;
        
        return model.image;
        
    }
}

-(NSString*)contentStr{
    
    if ([self.data isMemberOfClass:[Model class]]) {
        
        Model *model =  self.data;
        
        return model.conntentStr;
        
    }else{
        
        TestModel *model =  self.data;
        
        return model.conntentStr;
        
    }
}

@end
