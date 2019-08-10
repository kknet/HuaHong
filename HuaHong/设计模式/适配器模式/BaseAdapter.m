//
//  BaseAdapter.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "BaseAdapter.h"
@implementation BaseAdapter

- (instancetype)initWithData:(id)data{
    self = [super init];
    if (self) {
        
        self.data = data;
        
    }
    
    return self;
}

-(UIImage*)image{
    
    return nil;
}

-(NSString*)contentStr{
    
    return nil;
}

@end

