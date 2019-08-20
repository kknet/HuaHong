//
//  ContentView.m
//  HuaHong
//
//  Created by 华宏 on 2019/8/10.
//  Copyright © 2019 huahong. All rights reserved.
//

#import "ContentView.h"

#define Height   self.frame.size.height
#define Width    self.frame.size.width
@interface ContentView ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, strong) UILabel *labelContent;

@end
@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
        
    }
    return self;
}
- (void)setup {
    
    _imageView    = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,Height, Height)];
    
    [self addSubview:_imageView];
    
    _labelContent = [[UILabel alloc]initWithFrame:CGRectMake(Height+7, 0, Width -7-Height, Height)];
    
    [self addSubview:_labelContent];
}


-(void)loadData:(id  <BaseAdapterProtocol>)data{
    self.image      = [data image];
    self.contentStr = [data contentStr];
}

-(void)setImage:(UIImage *)image{
    _image           = image;
    _imageView.image = image;
}

-(void)setContentStr:(NSString *)contentStr{
    _contentStr         = contentStr;
    _labelContent.text  = contentStr;
}

@end

