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

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <Photos/Photos.h>
#import "QKAlertView.h"
#import "TTGTextTagCollectionView.h"

@interface TestViewController()
@property (nonatomic,strong) UILocalNotification *localNotification;

@property (strong, nonatomic)CTCallCenter *call_center;//电话管理

@end

@implementation TestViewController
{
    HUtils *_tool;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试";
    
//    [self monitorCall];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
//    HHSwitch *hhswitch = [[HHSwitch alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
//    [self.view addSubview:hhswitch];
//    [hhswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
   
    
//    HUtils *tool = [HUtils new];
//    _tool = tool;
//    [tool drawCircle:self.view.center radius:100 lineWidth:5 lineColor:[UIColor redColor].CGColor startAngle:-M_PI_2 endAngle:-M_PI_2+2*M_PI clockwise:YES duaring:5 mainView:self.view layerFrame:self.view.bounds];
    
//    TTGTextTagCollectionView *tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
//    [self.view addSubview:tagCollectionView];
//    [tagCollectionView addTags:@[@"TTG", @"Tag", @"collection", @"view"]];
//
//    UICountingLabel *myLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(20, 250, 280, 45)];
//    myLabel.textAlignment = NSTextAlignmentCenter;
//    myLabel.font = [UIFont fontWithName:@"Avenir Next" size:48];
//    myLabel.textColor = [UIColor colorWithRed:236/255.0 green:66/255.0 blue:43/255.0 alpha:1];
//    [self.view addSubview:myLabel];
//    //设置格式
//    myLabel.format = @"%.2f";
//
//    //设置分隔符样式
//    myLabel.positiveFormat = @"###,##0.00";
//
//    //设置变化范围及动画时间
//    [myLabel countFrom:0.00
//                         to:3198.23
//               withDuration:1.0f];
//
//    NSLog(@"familyNames:%@",[UIFont familyNames]);
    
    
    
}

- (void)showAlertView
{
    HHAlertView *alertView = [HHAlertView sharedAlertView];
//    HHAlertView *alertView = [alertView1 copy];
//    alertView.message = @"新华社北京3月13日电（记者叶昊鸣）记者13日从应急管理部了解到，财政部、应急管理部当日向青海省下拨中央自然灾害救灾资金1亿元，主要用于支持做好青海省玉树、果洛等地严重雪灾受灾群众救助工作，保障受灾群众基本生活。新华社北京3月13日电（记者叶昊鸣）记者13日从应急管理部了解到，财政部、应急管理部当日向青海省下拨中央自然灾害救灾资金1亿元，主要用于支持做好青海省玉树、果洛等地严重雪灾受灾群众救助工作，保障受灾群众基本生活。";
//    alertView.textAlignment = NSTextAlignmentLeft;
    alertView.message = @"哈哈哈哈哈哈哈哈";
    //    [alertView setSingleButton];


//    alertView.editable = YES;
//    alertView.placeholder = @"请输入...";
//    alertView.forbiddenEmoji = YES;
    
//    //此处有循环引用
    __weak typeof(self) weakSelf = self;
    [alertView setSureBlock:^(NSString * _Nonnull message) {
        weakSelf.title = message;
    }];
    
    [alertView setCancelBlock:^(NSString * _Nonnull message) {
        weakSelf.title = message;
    }];
    
    [alertView show];
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


- (void)buglyTest
{
    NSArray *array = @[@"1"];
    NSLog(@"%@",[array objectAtIndex:0]);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self buglyTest];
    
//    NSLog(@"weekdays:%@",weekdays);
    
//    [_tool dismiss];
    
//  UIViewController *vc = [[TestVC alloc]init];
//  [self presentViewController:vc animated:YES completion:nil];
////    [self.navigationController pushViewController:vc animated:YES];
//
//  UIViewController *vc1 =  self.presentedViewController;
//  UIViewController *vc2 =  self.presentingViewController;
//
//    //vc1:TestVC
//    NSLog(@"vc1:%@,vc2:%@",vc1,vc2);
    
//    TestView *testView = [[TestView alloc]initWithFrame:self.view.bounds];
//    testView.backgroundColor = [UIColor cyanColor];
//    [testView renderWithModel:nil];

//  UIView *snapshot =  [testView snapshotViewAfterScreenUpdates:YES];
//    [self.view addSubview:snapshot];
// UIGraphicsBeginImageContextWithOptions(snapshot.size, NO, [UIScreen mainScreen].scale);
//
//    [snapshot drawViewHierarchyInRect:snapshot.bounds afterScreenUpdates:NO];
//    UIImage *snapshotImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//
//        [PHAssetChangeRequest creationRequestForAssetFromImage:snapshotImg];
//
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        [SVProgressHUD showInfoWithStatus:@"保存成功"];
//    }];
    
    
//    NSArray *sortedParams = [@[@"a",@"c",@"b"] sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"sortedParams:%@",sortedParams);

    
//    [param.reverseObjectEnumerator.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSLog(@"obj:%@",obj);
//        [param removeObject:obj];
//    }];
    
    
//    [self share];
    
//    [self wechatLogin];
   
    
    
//    QKCodeController *vc = [QKCodeController codeControllerWithDismissCallback:^(BOOL isSuccess) {
//
//        NSLog(@"%d",isSuccess);
//    }];
//
//    [self presentViewController:vc animated:YES completion:nil];
   
//    [HUtils forceOrientation:UIInterfaceOrientationLandscapeLeft];
//    NSLog(@"%d",[HUtils isOrientationLandscape]);
    
    [self showAlertView];
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

#pragma mark - 电话监听-监测来电
- (void)monitorCall
{
    __weak typeof(self) weakSelf = self;
    
    _call_center = [[CTCallCenter alloc]init];
    _call_center.callEventHandler = ^(CTCall *call){
        
        if ([call.callState isEqualToString:CTCallStateIncoming]) {
            //来电
            NSLog(@"来电");
            
        }else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            //接通
//            _startDate = [NSDate date];
            NSLog(@"接通");

            
        }else if ([call.callState isEqualToString:CTCallStateDialing]) {
            //
            NSLog(@"正在拨打");

            
        }else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
            NSLog(@"断开");
//            _endDate = [NSDate date];
//            [weakSelf getCallTimeLength];
            
        }
    };
}

- (BOOL)navigationShouldPopOnBackButton
{
    if ([_delegate respondsToSelector:@selector(testReturnAction)]) {
        [_delegate testReturnAction];
    }
    return true;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
