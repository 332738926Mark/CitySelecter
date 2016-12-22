//
//  LocationManager.h
//  BaiduTest
//
//  Created by shendan on 16/12/9.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationManager : NSObject

+(LocationManager *)sharedLocationManager;

/**
 * @breif 开始定位
 */
-(void)startLocation;

/**
 * @breif 停止定位
 */
-(void)stopLocation;

/**
 *  @breif 判断是否授权开启定位
 */
-(BOOL)isAuthorizeOpenLocation;

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

@end
