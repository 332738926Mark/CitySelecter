//
//  CityPickerTableViewController.h
//  CitySelecter
//
//  Created by shendan on 16/12/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pickedCityCallBackBlock)(NSString *city);

@interface CityPickerTableViewController : UITableViewController

/**
 *  @param 城市数据源
 */
@property (strong, nonatomic) NSMutableDictionary *dataDict;

/**
 * @param 城市选择回调
 */
@property (copy, nonatomic) pickedCityCallBackBlock pickedCityCallBack;

@end
