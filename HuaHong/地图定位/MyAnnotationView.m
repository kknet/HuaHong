//
//  MyAnnotationView.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/17.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "MyAnnotationView.h"
#import "HHAnnotation.h"

@implementation MyAnnotationView

+(instancetype)myAnnotationViewWithMapView:(MKMapView *)mapView;
{
    static NSString *ID = @"annotation";
    MyAnnotationView *annoView = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MyAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:ID];
        
//        //设置左右两边自定义视图
//        annoView.canShowCallout = YES;
//        annoView.leftCalloutAccessoryView = [UISwitch new];
//        annoView.rightCalloutAccessoryView = [UISwitch new];
//
//        annoView.detailCalloutAccessoryView = [UISwitch new];
        
    }
    
    
    return annoView;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    HHAnnotation *myAnnotation = annotation;
    self.image = [UIImage imageNamed:myAnnotation.icon];
}
@end
