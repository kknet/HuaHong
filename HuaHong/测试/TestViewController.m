//
//  TestViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TestViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+Notification.h"
#import <Photos/Photos.h>
#import "TestModel.h"
#import "TestView.h"

@interface TestViewController()
@property (copy, nonatomic) NSString *str;
@end

@implementation TestViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
//  UIViewController *vc = [[TestVC alloc]init];
//  [self presentViewController:vc animated:YES completion:nil];
////    [self.navigationController pushViewController:vc animated:YES];
//
//  UIViewController *vc1 =  self.presentedViewController;
//  UIViewController *vc2 =  self.presentingViewController;
//
//    //vc1:TestVC
//    NSLog(@"vc1:%@,vc2:%@",vc1,vc2);
    

//  UIView *snapshot =  [testView snapshotViewAfterScreenUpdates:YES];
//  [self.view addSubview:snapshot];
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
    
    
//    //@selector(compare:)字符串自带的排序方法
//    NSArray *sortedParams = [@[@"a",@"c",@"b"] sortedArrayUsingSelector:@selector(compare:)];
//    NSLog(@"sortedParams:%@",sortedParams);
   
    
    

   
    
}

//- (void)verificationCode
//{
//    QKCodeController *vc = [QKCodeController codeControllerWithDismissCallback:^(BOOL isSuccess) {
//
//        NSLog(@"%d",isSuccess);
//    }];
//    [self presentViewController:vc animated:YES completion:nil];
//}

//-(void)share
//{
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession)]];
//
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//
////        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
//
//        [self shareTextToWechat];
//    }];
//}

//- (void)shareTextToWechat
//{
//    NSString *text = @"有没有发现不一样的地方？";
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    messageObject.text = text;
//    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        NSString *message = nil;
//        if (!error) {
//            message = [NSString stringWithFormat:@"分享成功"];
//        } else {
//            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }];
//}


//-(void)wechatLogin
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//
//        UMSocialUserInfoResponse *resp = result;
//
//        // 第三方登录数据(为空表示平台未提供)
//        // 授权数据
//        NSLog(@" uid: %@", resp.uid);
//        NSLog(@" openid: %@", resp.openid);
//        NSLog(@" accessToken: %@", resp.accessToken);
//        NSLog(@" refreshToken: %@", resp.refreshToken);
//        NSLog(@" expiration: %@", resp.expiration);
//
//        // 用户数据
//        NSLog(@" name: %@", resp.name);
//        NSLog(@" iconurl: %@", resp.iconurl);
//        NSLog(@" gender: %@", resp.unionGender);
//
//        // 第三方平台SDK原始数据
//        NSLog(@" originalResponse: %@", resp.originalResponse);
//    }];
//
//}



- (BOOL)navigationShouldPopOnBackButton
{
    return true;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
