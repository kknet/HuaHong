//
//  AnnotationController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/17.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "AnnotationController.h"
#import <MapKit/MapKit.h>
#import "HHAnnotation.h"

@interface AnnotationController ()<MKMapViewDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,assign) MKCoordinateSpan span;
@end

@implementation AnnotationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自定义大头针";
    
    [self.view addSubview:self.mapView];
    
}

-(MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        
        //跟踪模式
        _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
        
        //地图模式
        _mapView.mapType = MKMapTypeStandard;
        
        
        
        if (@available(iOS 9.0, *))
        {
            //设置交通
            _mapView.showsTraffic = YES;
            
            //设置指南针
            _mapView.showsCompass = YES;
            
            //设置比例尺
            _mapView.showsScale = YES;
            
            
        }
        
        //        开启地图的showsUserLocation属性，并设置方法setUserTrackMode:即可实现跟踪用户的位置和方向变化
        _mapView.showsUserLocation = YES;
        
        //        显示地图上的POI点
        _mapView.showsPointsOfInterest = YES;
        
    }
    
    return _mapView;
}

//返回以用户坐标为中心点
-(void)backUserLocationCenter
{
    //设置中心点
    //    self.mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    
    //或者
    //    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(_mapView. userLocation.location.coordinate.latitude, _mapView.userLocation.location.coordinate.longitude)];
    
    
    //设置范围
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.021250, 0.016090);
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, self.span) animated:YES];
}
#pragma mark MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.span = mapView.region.span;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (userLocation) {
        
        //创建编码对象
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        //反地理编码
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error || placemarks.count == 0) {
                return ;
            }
            //获取地标
            CLPlacemark *placemark=[placemarks lastObject];
            //设置标题
            userLocation.title=placemark.locality;
            //设置子标题
            userLocation.subtitle=placemark.name;
            
            
        }];
        
        
    }
    
}

#pragma mark -
//用 MKAnnotationView 设置图片和掉落效果
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        //不处理
        return nil;
    }
    
    
    static NSString *ID = @"annotation";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        
    }
    
    HHAnnotation *myAnnotation = annotation;
    annoView.image = [UIImage imageNamed:myAnnotation.icon];
    
    //设置掉落动画
    
    return annoView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
    //在添加大头针之前调用
    for (MKAnnotationView *AnnotationView in views) {
        
        if ([AnnotationView.annotation isKindOfClass:[MKUserLocation class]])
        {
            continue;
        }
        
        CGRect endFrame = AnnotationView.frame;
        AnnotationView.frame = CGRectMake(endFrame.origin.x, 0, endFrame.size.width, endFrame.size.height);
        
        [UIView animateWithDuration:0.25 animations:^{
            AnnotationView.frame = endFrame;
        }];
    }
}
#pragma mark 点击添加大头针
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //获取点击地图上的点
    CGPoint point = [[touches anyObject]locationInView:self.mapView];
    
    //将点转换成经纬度
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];

    HHAnnotation *annotation = [HHAnnotation new];
//    annotation.coordinate = CLLocationCoordinate2DMake(31.34807656703043, 121.363206362035);
    annotation.coordinate = coordinate;
    annotation.title = @"上海市";
    annotation.subtitle = @"顾村公园";
    annotation.icon = @"search_expert";
    
    [self.mapView addAnnotation:annotation];
}
@end

