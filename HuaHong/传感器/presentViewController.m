//
//  presentViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "presentViewController.h"

@interface presentViewController ()
@property (nonatomic, strong)UILabel *labInformation;

@end

@implementation presentViewController

- (UILabel *)labInformation {
    
    if (!_labInformation) {
        
        _labInformation = [[UILabel alloc] init];
    }
    
    return _labInformation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configLabel];
}

- (void)configLabel {
    
    self.labInformation.text = [NSString stringWithFormat:@"通过3DTouch按压屏幕显示的信息"];
    self.labInformation.textColor = [UIColor blackColor];
    self.labInformation.textAlignment = NSTextAlignmentCenter;
    self.labInformation.frame = CGRectMake(0, 0, 200, 30);
    [self.labInformation sizeToFit];
    CGPoint center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.labInformation.center = center;
    
    [self.view addSubview:self.labInformation];
}

#pragma mark - 3D Touch 预览Action代理
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    NSMutableArray *arrItem = [NSMutableArray array];
    
    UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"didClickCancel");
    }];
    
    UIPreviewAction *previewAction1 = [UIPreviewAction actionWithTitle:@"替换3DTouch标题" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        //把下标为index的元素替换成preview
        [self replaceItem];
        
    }];
    
    [arrItem addObjectsFromArray:@[previewAction0 ,previewAction1]];
    
    return arrItem;
}

- (void)replaceItem {
    
    
    //发送通知更新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_3DTouch" object:nil];
}

@end
