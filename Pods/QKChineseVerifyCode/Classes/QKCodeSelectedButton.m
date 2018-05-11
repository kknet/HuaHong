//
//  QKCodeSelectedButton.m
//  Code
//
//  Created by Sunny on 25/4/18.
//  Copyright © 2018年 Sunny. All rights reserved.
//

#import "QKCodeSelectedButton.h"
#import "QKChineseVerifyCodeFramework.h"

@implementation QKCodeSelectedButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    
}
-(void)setup{
    if (!self.selectedImgv) {
        self.selectedImgv = [[UIImageView alloc] init];
        self.selectedImgv.frame =CGRectMake(40, -5, 15, 15);
        [self addSubview:self.selectedImgv];
        self.selectedImgv.hidden = YES;
//        [self.selectedImgv setImage:[UIImage imageNamed:@"2Assistor"]];
        
        [self.selectedImgv setImage:[UIImage imageNamed:@"2Assistor" inBundle:[QKChineseVerifyCodeFramework frameworkBundle] compatibleWithTraitCollection:nil]];
    }
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectedImgv.hidden = !selected;
}
@end
