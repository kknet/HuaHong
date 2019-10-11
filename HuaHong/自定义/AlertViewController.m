//
//  AlertViewController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "AlertViewController.h"
#import "QKAlertView.h"

@interface AlertViewController ()<QKAlertViewDelegate>

@end

@implementation AlertViewController

/** 拜访话术 */
#define FGY_VISIT_VOICE_VERBAL @"FGY_VISIT_VOICE_VERBAL"
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self showAlertView];
    
    [[HHRequestManager defaultManager]requestByUrl:@"http://192.168.1.74/commonprovider/fgy/common/Sysconfig/getSysCfg" params:@{@"key" : FGY_VISIT_VOICE_VERBAL} requestType:POST
                                           success:^(id  _Nonnull responseObject) {
                                               //           [MBProgressHUD showMessage:@"请求成功"];
                                               NSDictionary *result1 = responseObject;
                                               NSInteger code = [[result1 objectForKey:@"result"] integerValue];
                                               if (code == 0) {
                                                   
                                                   NSArray *dataArr = [result1 objectForKey:@"data"];
                                                   NSDictionary *dic = dataArr.firstObject;
                                                    NSString * wordText = [dic objectForKey:@"value"];
                                                           
                                                   QKAlertView *alertView = [QKAlertView sharedAlertView];
                                                   
                                                   [alertView alertWithTitle:@"提示" message:wordText delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil buttonClickback:^(QKAlertView * _Nonnull alertView,NSString *message, NSInteger buttonIndex) {
                                                       
                                                   }];
                                                   
                                                   alertView.title = @"不合格说明";
//                                                   alertView.placeholder = @"请说明不合格原因";
                                                   alertView.textAlignment = NSTextAlignmentLeft;
//                                                   alertView.editable = YES;
//                                                   alertView.limitCount = 200;
//                                                   alertView.forbiddenEmoji = YES;
                                                   //    [alertView exchangeTwoButton];
                                                   
                                                   [alertView show];
                                                   
                                               }
                                               
                                           } failure:^(RequestErrorType error) {
                                               [MBProgressHUD showMessage:@"请求失败"];
                                               
                                           } isSupportHud:YES isSupportErrorAlert:YES];
    
    
}


- (void)showAlertView
{
    
    NSString *message = @"新华社北京3月13日电（记者叶昊鸣）记者13日从应急管理部了解到，财政部、应急管理部当日向青海省下拨中央自然灾害救灾资金1亿元，主要用于支持做好青海省玉树、果洛等地严重雪灾受灾群众救助工作，保障受灾群众基本生活。新华社北京3月13日电（记者叶昊鸣）记者13日从应急管理部了解到，财政部、应急管理部当日向青海省下拨中央自然灾害救灾资金1亿元，主要用于支持做好青海省玉树、果洛等地严重雪灾受灾群众救助工作，保障受灾群众基本生活。";
    //    NSAttributedString *attrMessage = [[NSAttributedString alloc]initWithString:message];
    
    
    QKAlertView *alertView = [QKAlertView sharedAlertView];
    
    [alertView alertWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" buttonClickback:^(QKAlertView * _Nonnull alertView,NSString *message, NSInteger buttonIndex) {
        
            if (buttonIndex == 0) {
                [MBProgressHUD showMessage:@"取消"];
            }else
            {
                [MBProgressHUD showMessage:@"确定"];
            }
    
    }];
    
    alertView.title = @"不合格说明";
    alertView.placeholder = @"请说明不合格原因";
    alertView.textAlignment = NSTextAlignmentLeft;
    alertView.editable = YES;
    alertView.limitCount = 200;
    alertView.forbiddenEmoji = YES;
//    [alertView exchangeTwoButton];
    
    [alertView show];
    
}

- (void)alertView:(QKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [MBProgressHUD showMessage:@"取消"];
    }else
    {
        [MBProgressHUD showMessage:@"确定"];
    }
}


@end
