//
//  SearchResultTableViewController.h
//  CitySelecter
//
//  Created by shendan on 16/12/20.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChineseToPinyin.h"

@interface SearchResultTableViewController : UITableViewController<UISearchResultsUpdating>

@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) NSMutableArray *allCitiesArr;

@end
