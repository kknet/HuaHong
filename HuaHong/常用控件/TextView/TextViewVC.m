//
//  TextViewController.m
//  HuaHong
//
//  Created by 华宏 on 2018/3/23.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "TextViewVC.h"
#import "SystemServices.h"
#import "HHAttachment.h"
@interface TextViewVC ()<UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;
@end

@implementation TextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
//    self.textView.editable = NO;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"硬件信息" style:UIBarButtonItemStylePlain target:self action:@selector(getSystemInfo)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
     self.textView.placeholder = @"placeholder";
    self.textView.placeholderColor = [UIColor redColor];

}

-(void)getSystemInfo
{
    //获取硬件信息
    SystemServices *system = [SystemServices sharedServices];
    NSString *systemInfo = system.allSystemInformation.description;
    
    //图文混排
//    NSMutableAttributedString *attrStr = [NSMutableAttributedString alloc]initWithString:<#(nonnull NSString *)#> attributes:<#(nullable NSDictionary<NSAttributedStringKey,id> *)#>

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:systemInfo];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, systemInfo.length)];
    
    // 创建图片图片附件
    HHAttachment *attachment = [[HHAttachment alloc]init];
    UIImage *image = [UIImage imageNamed:@"search_expert"];
    attachment.image = image;
//    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSAttributedString *attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [attrStr insertAttributedString:attachmentStr atIndex:systemInfo.length];
    
        //超链接
    [attrStr addAttribute:NSLinkAttributeName value:[@"http://www.baidu.com" encodeString] range:[systemInfo rangeOfString:@"SystemName"]];
    
    // 段落
    // NSParagraphStyle
    NSMutableParagraphStyle  *style = [[NSMutableParagraphStyle alloc] init];
    
    //1.首行 缩进  ( 管理第一行)
    style.firstLineHeadIndent = 20.f;
    
    // 2.缩进（管理 除第一行以外的行）
    style.headIndent = 20;
    
    //3.行间距倍数
    style.lineHeightMultiple = 1;
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, systemInfo.length)];
    
    self.textView.attributedText = attrStr;
    
}


- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    NSLog(@"%@",URL);
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    
    NSLog(@"textAttachment");

    return YES;
}
@end
