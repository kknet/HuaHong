//
//  MapViewController.m
//  HuaHong
//
//  Created by 华宏 on 2017/11/24.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
@interface MapViewController ()<MKMapViewDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Map";

    [self.view addSubview:self.mapView];
}

-(MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.mapType = MKMapTypeStandard;
        if (@available(iOS 9.0, *)) {
            _mapView.showsTraffic = YES;
        } else {
            // Fallback on earlier versions
        }
        _mapView.showsScale = YES;
        _mapView.showsCompass = YES;
        _mapView.showsUserLocation = YES;
        _mapView.showsPointsOfInterest = YES;

        MKCoordinateSpan span=MKCoordinateSpanMake(0.021250, 0.016090);
        
        [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
        
        
    }
    
    return _mapView;
}
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (userLocation) {
        //创建编码对象
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        //反地理编码
        [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error!=nil || placemarks.count==0) {
                return ;
            }
            //获取地标
            CLPlacemark *placemark=[placemarks firstObject];
            //设置标题
            userLocation.title=placemark.locality;
            //设置子标题
            userLocation.subtitle=placemark.name;
//            [self fetchNearbyInfo:userLocation.location.coordinate.latitude andT:userLocation.location.coordinate.longitude];
        }];
        
  [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude)];
        
    }
    
}




@end
