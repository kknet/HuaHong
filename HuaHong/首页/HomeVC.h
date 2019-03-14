//
//  HomeVC.h
//  HuaHong
//
//  Created by 华宏 on 2017/11/22.
//  Copyright © 2017年 huahong. All rights reserved.
//

/**
 * Cmd+Shift+o         快速查找类
 * Ctrl+6              列出当前文件所有方法
 * Ctrl+Cmd+up         切换.h和.m
 * Cmd+Shift+Y         显示/隐藏控制台
 * Cmd+Ctrl+Left/Right 到上/下一次编辑的位置
 * Cmd+T               新建tab栏
 * Cmd+Shift+[         切换tab栏
 * ESC                 代码补全
 */
#import <UIKit/UIKit.h>

@interface HomeVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>

-(void)completationHandler:(void (^)(UIBackgroundFetchResult))completationHandler;

/**
 * <# #>
UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
 
 [self submitData];
 }]];
 
 [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 
 }]];
 
 
 UIView *subView1 = alertCtrl.view.subviews[0];
 UIView *subView2 = subView1.subviews[0];
 UIView *subView3 = subView2.subviews[0];
 UIView *subView4 = subView3.subviews[0];
 UIView *subView5 = subView4.subviews[0];
 UILabel *messageLab = subView5.subviews[2];
 messageLab.textAlignment = NSTextAlignmentLeft;
 
 NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
 style.lineSpacing = 5;
 NSDictionary *attributes = @{NSParagraphStyleAttributeName:style};
 messageLab.attributedText = [[NSAttributedString alloc]initWithString:messageLab.text attributes:attributes];
 
 [self presentViewController:alertCtrl animated:YES completion:nil];

 */
@end
