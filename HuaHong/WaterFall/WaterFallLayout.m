//
//  WaterFallLayout.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/30.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "WaterFallLayout.h"

@implementation WaterFallLayout{
    
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeAttay;
}


//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    _attributeAttay = [[NSMutableArray alloc]init];
    [super prepareLayout];
    //演示方便 我们设置为静态的2列
    //计算每一个item的宽度
    
    //    float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/2;
    float WIDTH = ([UIScreen mainScreen].bounds.size.width-margin*3)/2;
    
    
    //定义数组保存每一列的高度
    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
    CGFloat colHight[2] = {self.sectionInset.top,self.sectionInset.bottom};
    
    for (int i=0; i<_itemCount; i++) {
        
        NSIndexPath *IndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:IndexPath];
        
        CGFloat hight ;
        CGFloat bigHeight = WIDTH-15;
        CGFloat smallHeight = (bigHeight-margin)/2;
        
        if (IndexPath.item ==0 ||IndexPath.item ==2 || IndexPath.item ==4 || IndexPath.item ==8 )
        {
            
            hight = bigHeight;
            
        }else
        {
            hight = smallHeight;
            
        }
        
        //标记最短的列
        int index =0;
        if (colHight[0] > colHight[1])
        {
            colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
            index=1;
        }else{
            
            //将新的item高度加入到短的一列
            colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
            index=0;
        }
        
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*index, colHight[index]-hight-self.minimumLineSpacing, WIDTH, hight);
        [_attributeAttay addObject:attris];
    }
    
    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
    if (colHight[0] > colHight[1])
    {
        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }else
    {
        self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
    }
    
}

#pragma mark--这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributeAttay;
}

@end

