//
//  ContentView.h
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAdapter.h"
@interface ContentView : UIView

/**
 *  添加符合BaseAdapterProtocol协议的数据类
 */
-(void)loadData:(id<BaseAdapterProtocol>)data;

@end

