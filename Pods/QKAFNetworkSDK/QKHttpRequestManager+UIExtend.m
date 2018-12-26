//
//  QKHttpRequestManager+UIExtend.m
//  QKPublic
//
//  Created by chenhanlin on 2017/9/8.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import "QKHttpRequestManager+UIExtend.h"
#import "SVProgressHUD.h"
#import "UIImage+GIF.h"

@implementation QKHttpRequestManager (UIExtend)

- (void)startLoading {

    [SVProgressHUD showWithStatus:@"加载中..."];
}

- (void)netLoading
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    if (self.loadingGifName) {
        [SVProgressHUD showImage:[UIImage imageWithGIFNamed:self.loadingGifName] status:@"亲，您的手机貌似没联网"];
    } else {
        [SVProgressHUD showWithStatus:@"亲，您的手机貌似没联网"];
    }
    [SVProgressHUD dismissWithDelay:1.f];
}
- (ProgressCallback)startFileLoading {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showProgress:0 status:@"文件传输中..."];
    ProgressCallback callback = ^(float progress) {
        [SVProgressHUD showProgress:progress status:@"文件传输中..."];
    };
    return callback;
}

- (void)stopLoading {
    [SVProgressHUD dismiss];
}

- (void)showErrorMsg:(NSString *)msg {
    [SVProgressHUD showInfoWithStatus:msg];
    [SVProgressHUD dismissWithDelay:1.f];
}

#pragma mark -(gif - image)


@end
