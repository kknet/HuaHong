//
//  QKChineseVerifyCodeFramework.m
//  MBProgressHUD
//
//  Created by Sunny on 25/4/18.
//

#import "QKChineseVerifyCodeFramework.h"

@implementation QKChineseVerifyCodeFramework

+(NSBundle *)frameworkBundle{
    
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL * bundleURL = [podBundle URLForResource:@"QKChineseVerifyCodeFramework" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    return bundle;
    
}

@end
