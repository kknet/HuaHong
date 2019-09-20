//
//  PickerViewController.m
//  HuaHong
//
//  Created by 华宏 on 2019/9/20.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "PickerViewController.h"
#import "QKPickerView.h"

@interface PickerViewController ()<QKPickerViewDelegate>
@property (nonatomic,strong) QKPickerView *pickerView;
@end

@implementation PickerViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.pickerView show];
}

- (QKPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[QKPickerView alloc]initWithDataSource:@[@"计时器",@"密码安全",@"正则表达式",@"分段选择",@"埋点",@"AddChildVC"]];
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

- (void)pickerView:(QKPickerView *)pickerView didSelectRow:(NSInteger)row selectData:(NSString *)selectStr{
  
    NSLog(@"didSelectRow:%ld",(long)row);
    NSLog(@"selectData:%@",selectStr);
    self.title = selectStr;

}

@end
