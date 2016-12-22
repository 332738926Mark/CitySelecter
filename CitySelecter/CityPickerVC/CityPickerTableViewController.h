//
//  CityPickerTableViewController.h
//  CitySelecter
//
//  Created by shendan on 16/12/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityPickerTableViewController : UITableViewController

/**
 *  @param 城市数据源
 */
@property (strong, nonatomic) NSMutableDictionary *dataDict;

@end
