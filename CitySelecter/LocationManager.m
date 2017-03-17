//
//  LocationManager.m
//  BaiduTest
//
//  Created by shendan on 16/12/9.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (strong, nonatomic) BMKLocationService *localService;
@property (strong, nonatomic) BMKGeoCodeSearch *geoSearch;

@end

@implementation LocationManager

+(LocationManager *)sharedLocationManager {
    static LocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc] init];
    });
    return manager;
}

-(instancetype)init {
    if (self = [super init]) {
        _localService = [[BMKLocationService alloc] init];
        _localService.delegate = self;
        // 设定定位的最小更新距离(米)，更新频率。默认为kCLDistanceFilterNone
        _localService.distanceFilter = 100.f;
        // 设定定位精度。默认为kCLLocationAccuracyBest。
        _localService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _geoSearch = [[BMKGeoCodeSearch alloc] init];
        _geoSearch.delegate = self;
    }
    return self;
}

-(void)startLocation {
    if ([self isAuthorizeOpenLocation]) {
        [_localService startUserLocationService];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在设置中开启定位服务" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
        [alert show];
    }
}

-(void)stopLocation {
    [_localService stopUserLocationService];
}

-(BOOL)isAuthorizeOpenLocation {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
         [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            return YES;
    }
    return NO;
}

-(void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    CLLocationCoordinate2D coor = (CLLocationCoordinate2D){self.latitude, self.longitude};
    BMKReverseGeoCodeOption *reverseOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseOption.reverseGeoPoint = coor;
    BOOL result = [_geoSearch reverseGeoCode:reverseOption];
    if (result) {
        NSLog(@"反geo检索发送成功");
    }else{
        NSLog(@"反geo检索发送失败");
    }
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"%@--%@",result.addressDetail.city, result.address);
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentAddress"] isEqualToString:result.address]) {
            [self stopLocation];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:result.addressDetail.city forKey:@"UserCurrentCity"];
            [[NSUserDefaults standardUserDefaults] setValue:result.address forKey:@"UserCurrentAddress"];
        }
    }else{
        [self startLocation];
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex == 1) { // 去设置
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
