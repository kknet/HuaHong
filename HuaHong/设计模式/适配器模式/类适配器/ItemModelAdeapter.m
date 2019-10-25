//
//  ItemModelAdeapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ItemModelAdeapter.h"
#import "TestModel.h"
@implementation ItemModelAdeapter

-(UIImage*)image{
    
    TestModel *model =  self.data;
    
    return model.image;
}

-(NSString*)contentStr{
    TestModel *model =  self.data;
    
    return model.conntentStr;
    
}

@end

