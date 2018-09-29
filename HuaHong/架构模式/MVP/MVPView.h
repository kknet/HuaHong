//
//  MVPView.h
//  HuaHong
//
//  Created by 华宏 on 2018/9/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVPViewDelegate <NSObject>
- (void)viewCilcked;
@end

@interface MVPView : UIView

- (void)printOnView:(NSString *)content;

@property (nonatomic,weak) id<MVPViewDelegate> delegate;
@end
