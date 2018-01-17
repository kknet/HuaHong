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
    
    self.title = @"地图";
    
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

/**
 //  MKPinAnnotationView 是 MKAnnotationView 的子类
 //   用MKPinAnnotationView设置颜色和掉落效果
 -(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
 {
 if ([annotation isKindOfClass:[MKUserLocation class]]) {
 //不处理
 return nil;
 }
 
 
 static NSString *ID = @"annotation";
 MKPinAnnotationView *annoView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ID];
 if (annoView == nil) {
 annoView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
 
 }
 
 //    //ios9过期
 //    annoView.pinColor = MKPinAnnotationColorGreen;
 
 //iOS9 later
 annoView.pinTintColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
 
 //设置掉落动画
 annoView.animatesDrop = YES;
 
 return annoView;
 }
 
 */

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
        annoView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        
    }
    
    HHAnnotation *myAnnotation = annotation;
    annoView.image = [UIImage imageNamed:myAnnotation.icon];
    
    //设置掉落动画
    
    return annoView;
}
#pragma mark 添加大头针
-(void)addAnnotation
{
    HHAnnotation *annotation = [HHAnnotation new];
    annotation.coordinate = CLLocationCoordinate2DMake(31.34807656703043, 121.363206362035);
    annotation.title = @"上海市";
    annotation.subtitle = @"顾村公园";
    annotation.icon = @"MyRoom";
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark 点击添加大头针
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //获取点击地图上的点
//    CGPoint point = [[touches anyObject]locationInView:self.mapView];
//
//    //将点转换成经纬度
//    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
//
//    HHAnnotation *annotation = [HHAnnotation new];
//    annotation.coordinate = coordinate;
//
//    //创建编码对象
//    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
//    CLLocation *location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    //反地理编码
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (error || placemarks.count == 0) {
//            return ;
//        }
//        //获取地标
//        CLPlacemark *placemark=[placemarks lastObject];
//        //设置标题
//        annotation.title=placemark.locality;
//        //设置子标题
//        annotation.subtitle=placemark.name;
//        annotation.icon = @"search_expert";
//
//
//    }];
//
//    [self.mapView addAnnotation:annotation];
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addAnnotation];
    
}
@end

