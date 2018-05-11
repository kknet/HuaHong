//
//  HHSegmentView.m
//  HuaHong
//
//  Created by 华宏 on 2018/5/8.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "HHSegmentView.h"
#define kHeight 40
@interface HHSegmentView ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HHSegmentView

-(void)setItemArr:(NSArray *)itemArr
{
    _itemArr = itemArr;
    
    CGFloat offsetX = 20;
    for (int i = 0; i < itemArr.count; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = itemArr[i];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:14];
        CGRect frame = label.frame;
        frame = CGRectMake(offsetX, 0, frame.size.width, kHeight);
        label.frame = frame;
        
        offsetX = offsetX + frame.size.width + 10;
        
        [self.scrollView addSubview:label];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClick:)];
        [label addGestureRecognizer:tap];
    }
    
    self.scrollView.contentSize = CGSizeMake(offsetX, kHeight);

    [self setScale:1 PageIndex:0];
}

-(void)itemClick:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(segmentView:clickWhithIndex:)])
    {
        
        NSInteger index = [self.scrollView.subviews indexOfObject:gesture.view];
        [self.delegate segmentView:self clickWhithIndex:index];
        
        [UIView animateWithDuration:0.25 animations:^{
          
            for (int i=0; i<self.scrollView.subviews.count; i++) {
                if (i == index)
                {
                    [self setScale:1.0 PageIndex:i];
                }else
                {
                    [self setScale:0 PageIndex:i];
                }
            }
        }];
        

        [self scrollToCenter:gesture.view];

    }
}

-(void)setScale:(CGFloat)scale PageIndex:(NSInteger)pageIndx
{
    if (pageIndx < self.scrollView.subviews.count)
    {
        UILabel *label = [self.scrollView.subviews objectAtIndex:pageIndx];
        
        CGFloat fontSize = 14 + (18-14)*scale;
        //    label.font = [UIFont systemFontOfSize:fontSize];
        label.transform = CGAffineTransformMakeScale(fontSize/14, fontSize/14);
        
        label.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1.0];
        
        [self scrollToCenter:label];

    }
    
 
}

-(void)scrollToCenter:(UIView *)view
{
    CGFloat offsetX = view.center.x - self.scrollView.frame.size.width * 0.5;
    
    /** scrollView前面不滚动 */
    if (offsetX < 0) {
        offsetX = 0;
    }
    

    /** scrollView后面滚动到最后 */
    if (self.scrollView.contentSize.width  - view.frame.origin.x <= self.scrollView.frame.size.width) {
       
      offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}
@end
