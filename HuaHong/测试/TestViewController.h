//
//  TestViewController.h
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TestDelegate <NSObject>
- (void)testReturnAction;
@end

@interface TestViewController : BaseViewController
@property (nonatomic,assign) CGFloat hFloat;

@property (nonatomic,weak) id<TestDelegate> delegate;
@end
