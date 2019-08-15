//
//  BaseAdapterProtocol.h
//  HuaHong
//
//  Created by qk-huahong on 2019/8/15.
//  Copyright © 2019 huahong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseAdapterProtocol <NSObject>
-(UIImage*)image;
-(NSString*)contentStr;
- (void)testMethod;
@end

NS_ASSUME_NONNULL_END
