//
//  DeleteFileController.m
//  HuaHong
//
//  Created by 华宏 on 2018/4/12.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "DeleteFileController.h"

@interface DeleteFileController ()

@end

@implementation DeleteFileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self deletedata];
}

#pragma mark - delete 删除文件
-(void)deletedata
{
    NSString *urlStr = [kBaseURL stringByAppendingPathComponent:@"uploads/123.mp4"];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15.0];
    [request setHTTPMethod:@"delete"];
    
    //Authorization    Basic YWRtaW46OTAxMTI0
    [request setValue:[self getAuthorization:@"admin" pwd:@"901124"]forHTTPHeaderField:@"Authorization"];
    
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"--data:%@",str);
        NSLog(@"--response:%@",response);
    }]resume];
}

-(NSString *)getAuthorization:(NSString *)userName pwd:(NSString *)pwd
{
    NSString *tmpStr = [NSString stringWithFormat:@"%@:%@",userName,pwd];
    tmpStr = [tmpStr base64Encode];
    NSString *authorizationStr = [NSString stringWithFormat:@"Basic %@",tmpStr];
    return authorizationStr;
}


@end
