//
//  SearchResultTableViewController.m
//  CitySelecter
//
//  Created by shendan on 16/12/20.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import "SearchResultTableViewController.h"

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

-(NSMutableArray *)resultArr
{
    if (!_resultArr) {
        _resultArr = [[NSMutableArray alloc] init];
    }
    return _resultArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                @"reuseIdentifier"];
    }
    cell.textLabel.text = _resultArr[indexPath.row];
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 0 && ![searchString isEqualToString:@""]) {
        [_resultArr removeAllObjects];
        for (int i=0; i<_allCitiesArr.count; i++) {
            if ([[ChineseToPinyin pinyinFromChiniseString:_allCitiesArr[i]] hasPrefix:[searchString uppercaseString]] || [_allCitiesArr[i] hasPrefix:searchString]) {
                [_resultArr addObject:_allCitiesArr[i]];
            }
        }
        [self.tableView reloadData];
    }
}

@end
