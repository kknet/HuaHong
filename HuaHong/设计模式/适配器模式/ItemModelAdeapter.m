//
//  ItemModelAdeapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ItemModelAdeapter.h"
#import "ItemModel.h"
@implementation ItemModelAdeapter

-(UIImage*)image{
    
    ItemModel *model =  self.data;
    
    return model.image;
}

-(NSString*)contentStr{
    ItemModel *model =  self.data;
    
    return model.conntentStr;
    
}

@end

