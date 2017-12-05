//
//  ChoisePhotoCell.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "PhotoListCell.h"

@implementation PhotoListCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _photoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.layer.masksToBounds = YES;
        [self addSubview:_photoView];
        
        _signImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-22-5, 5, 22, 22)];
        _signImage.layer.cornerRadius = 22/2;
        _signImage.image = [UIImage imageNamed:@"wphoto_select_no"];
        _signImage.layer.masksToBounds = YES;
        [_photoView addSubview:_signImage];
        
    }
    
    return self;
}
@end
