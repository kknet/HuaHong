//
//  TestViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TestViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "AppDelegate+Notification.h"
#import "CollectionHeadView.h"
#import "HomeFlowLayout.h"
#import <UShareUI/UShareUI.h>
#import "TestView.h"
#import <QKCodeController.h>

@interface TestViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UILocalNotification *localNotification;
@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation TestViewController
{
    BOOL _isScrollDown;//滚动方向
    NSInteger _selectIndex;//记录位置

}

static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
//    [self.view addSubview:self.collectionView];
    
//    HHSwitch *hhswitch = [[HHSwitch alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
//    [self.view addSubview:hhswitch];
//
//    hhswitch.onText = @"打开";
//    hhswitch.offText = @"关闭";
//
//    hhswitch.backgroundColor = [UIColor clearColor];
//    hhswitch.tintColor = [UIColor lightGrayColor];
//    hhswitch.thumbTintColor = [UIColor redColor];
//
//    [hhswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)switchAction:(HHSwitch *)sender
{
    if (sender.isOn)
    {
        NSLog(@"开始接单");
    }else
    {
        NSLog(@"接单已关");

    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSArray *arr = @[@"11",@"aa",@"哈哈"];
    NSString *str = [arr componentsJoinedByString:@"&"];
    NSLog(@"str:%@",str);
    
//    [self.segment setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} forState:UIControlStateNormal];
    
//    [UIViewController showAlertWhithTarget:self Title:@"提示" Message:@"Alert测试" SureTitle:@"确定" CancelTitle:@"取消" SureAction:^{
//        NSLog(@"sure");
//    } CancelAction:nil];
    
    
//  TestView *view =  [[TestView alloc]init];
//
//  [self.view addSubview:view];
    
    
    
//    [self share];
    
//    [self wechatLogin];
   
    
//    NSString *str = [NSString stringWithFormat:@"%f",self.hFloat];
//    [SVProgressHUD showWithStatus:str];
    
//    QKCodeController *vc = [QKCodeController codeControllerWithDismissCallback:^(BOOL isSuccess) {
//
//        NSLog(@"%d",isSuccess);
//    }];
//
//    [self presentViewController:vc animated:YES completion:nil];
}

-(void)share
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
//        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
        
        [self shareTextToWechat];
    }];
}

- (void)shareTextToWechat
{
    NSString *text = @"有没有发现不一样的地方？";
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = text;
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        } else {
            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
}


-(void)wechatLogin
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
    
    
    
    
    
}


/*
#define kSwitchHeight 50
- (void)addSwitch
{
 
        NSString *showText = @"显示名称";
        // 2个字 用80比较好看 (18号字体)
        // 4个字 用120比较好看 (18号字体)
        // 所以: = 字数 * 20 + 40
        CGFloat switchWidth = showText.length * 20 + 40;//120;
        
        _switch_showName = [[ZJSwitch alloc] initWithFrame:CGRectMake(0, 0, switchWidth, kSwitchHeight)];
        
        
 
        
        _switch_showName.backgroundColor = [UIColor clearColor];
        _switch_showName.tintColor = [UIColor lightGrayColor];
        _switch_showName.onText = showText;
        _switch_showName.offText = showText; // 也可以不一样
        [_switch_showName addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_switch_showName];
 
 
}
 
 */
@end
