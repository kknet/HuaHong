//
//  SystemNavigationController.m
//  HuaHong
//
//  Created by 华宏 on 2018/1/18.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "SystemNavigationController.h"
#import <MapKit/MapKit.h>
@interface SystemNavigationController ()<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SystemNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
}

- (IBAction)navigationAction:(id)sender
{
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:self.textField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            return ;
        }
        
        CLPlacemark *clplacemark = [placemarks lastObject];
        MKPlacemark *mkplacemark = [[MKPlacemark alloc]initWithPlacemark:clplacemark];
        MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:mkplacemark];
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit,MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsShowsTrafficKey:@(YES)};
        [ MKMapItem openMapsWithItems:@[mapItem] launchOptions:options];
        
    }];
    
}

- (IBAction)drawLine:(id)sender
{
    [self.textField resignFirstResponder];
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder geocodeAddressString:self.textField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            return ;
        }
        
        CLPlacemark *clplacemark = [placemarks lastObject];
        MKPlacemark *mkplacemark = [[MKPlacemark alloc]initWithPlacemark:clplacemark];
        
        //起点
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        
        //终点
        MKMapItem *destinationItem = [[MKMapItem alloc]initWithPlacemark:mkplacemark];
       
        //实现画线
        //1.创建方向请求对象
        MKDirectionsRequest *request = [MKDirectionsRequest new];
        request.source = sourceItem;
        request.destination = destinationItem;
        MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
        
        //计算两点之间的路线
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            
            if (response.routes.count == 0 || error) {
                return ;
            }
            
            //获取路线信息
            for (MKRoute *route in response.routes) {
                
                //折线
                MKPolyline *polyline = route.polyline;
                
                [self.mapView addOverlay:polyline];
            }
        }];
        
    }];
}

#pragma mark - 设置地图渲染物
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *polyline = [[MKPolylineRenderer alloc]initWithOverlay:overlay];
    polyline.strokeColor = [UIColor redColor];//必须
    polyline.lineWidth = 3;
    
    return polyline;
}
@end
