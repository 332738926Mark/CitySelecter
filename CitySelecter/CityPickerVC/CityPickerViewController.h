//
//  CityPickerViewController.h
//  CitySelecter
//
//  Created by shendan on 2017/3/31.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pickedCityCallBackBlock)(NSString *city);

@interface CityPickerViewController : UIViewController

/**
 *  @param 城市数据源
 */
@property (strong, nonatomic) NSMutableDictionary *dataDict;

/**
 * @param 城市选择回调
 */
@property (copy, nonatomic) pickedCityCallBackBlock pickedCityCallBack;

@end
