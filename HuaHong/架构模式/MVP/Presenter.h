//
//  Presenter.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVPView.h"
#import "MVPModel.h"
@interface Presenter : NSObject<MVPViewDelegate>
@property (nonatomic,strong) MVPView *mvpView;
@property (nonatomic,strong) MVPModel *model;

- (void)printTask;
@end
