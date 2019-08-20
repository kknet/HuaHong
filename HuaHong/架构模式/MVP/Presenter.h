//
//  Presenter.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentDelegate.h"
#import "MVPModel.h"

@interface Presenter : NSObject<PresentDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

// 加载数据
- (void)loadData;

@property (nonatomic, weak) id<PresentDelegate> delegate;


@end
