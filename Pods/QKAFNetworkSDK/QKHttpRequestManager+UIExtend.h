//
//  QKHttpRequestManager+UIExtend.h
//  QKPublic
//
//  Created by chenhanlin on 2017/9/8.
//  Copyright © 2017年 qk365. All rights reserved.
//

#import "QKHttpRequestManager.h"

typedef void(^ProgressCallback)(float progress);

@interface QKHttpRequestManager (UIExtend)

- (void)netLoading;

- (void)startLoading;

- (ProgressCallback)startFileLoading;

- (void)stopLoading;

- (void)showErrorMsg:(NSString *)msg;

@end
