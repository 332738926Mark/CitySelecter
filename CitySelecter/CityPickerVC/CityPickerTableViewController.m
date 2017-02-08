//
//  CityPickerTableViewController.m
//  CitySelecter
//
//  Created by shendan on 16/12/19.
//  Copyright © 2016年 Mark. All rights reserved.
//
#define ADDED_CELL_ROWS 2

#import "CityPickerTableViewController.h"
#import "SearchResultTableViewController.h"
#import "LocationManager.h"

#import "MKHotCityCell.h"

@interface CityPickerTableViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;
//@property (strong, nonatomic) SearchResultTableViewController *searchResultVC;
@property (strong, nonatomic) NSArray *hotCitiesArr;
@property (strong, nonatomic) NSMutableArray *allCitiesArr;
@property (strong, nonatomic) NSMutableArray *titleArray;
@property (strong, nonatomic) MKHotCityCell *hotCityCell;
@property (assign, nonatomic) BOOL isAuthorized;

@end

@implementation CityPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionIndexColor = RGBACOLOR(255, 198, 168, 1);
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _isAuthorized = [LocationManager sharedLocationManager].isAuthorizeOpenLocation;
    self.title = @"城市选择";
    [self initData];
    [self setupSearchController];
}

-(void)initData
{
    _hotCitiesArr = @[@"北京",@"深圳",@"上海",@"广州",@"香港",@"西安",@"珠海",@"湛江",@"佛山"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    _dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    _allCitiesArr = [[NSMutableArray alloc] init];
    NSArray *allCityKeys = [_dataDict allKeys];
    for (int i=0; i<_dataDict.count; i++) {
        [_allCitiesArr addObjectsFromArray:_dataDict[allCityKeys[i]]];
    }
    _titleArray = [[NSMutableArray alloc] init];
    for (int i=0; i<26; i++) {
        if (i == 8 || i == 14 || i == 20 || i == 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [_titleArray addObject:cityKey];
    }
}

//-(SearchResultTableViewController *)searchResultVC
//{
//    if (!_searchResultVC) {
//        _searchResultVC = [[SearchResultTableViewController alloc] init];
//        _searchResultVC.dataDict = self.dataDict;
//    }
//    return _searchResultVC;
//}


-(void)setupSearchController
{
    SearchResultTableViewController *searchResultVC = [[SearchResultTableViewController alloc] init];
    searchResultVC.allCitiesArr = self.allCitiesArr;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    _searchController.searchResultsUpdater = searchResultVC;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.placeholder = @"输入城市名/拼音";
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchController.searchBar sizeToFit];
  
    self.navigationItem.titleView = _searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchResultsUpdating

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search");
}

#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchController.searchBar.showsCancelButton = YES;
    NSArray *subviews;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        subviews = [self.searchController.searchBar.subviews[0] subviews];
    } else {
        subviews = self.searchController.searchBar.subviews;
    }
    
    for (id view in subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isAuthorized) {
        return [_dataDict allKeys].count + ADDED_CELL_ROWS;
    }else{
        return [_dataDict allKeys].count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isAuthorized) {
        if (section == 0 || section == 1) {
           return 1;
        }else{
            NSString *cityKey = _titleArray[section - ADDED_CELL_ROWS];
            NSArray *array = _dataDict[cityKey];
            return array.count;
        }
    }else{
        if (section == 0) {
            return 1;
        }else{
            NSString *cityKey = _titleArray[section - 1];
            NSArray *array = _dataDict[cityKey];
            return array.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAuthorized) {
        if (indexPath.section == 0) {
            UITableViewCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"location"];
            if (locationCell == nil) {
                locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"location"];
            }
            locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
            locationCell.textLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"];
            locationCell.textLabel.font = FONT_14;
            return locationCell;
        }else if (indexPath.section == 1){
            _hotCityCell = [tableView dequeueReusableCellWithIdentifier:@"HotCityCell"];
            if (_hotCityCell == nil) {
                _hotCityCell = [[MKHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" withCityArray:_hotCitiesArr];
            }
            _hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _hotCityCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *cityKey = [_titleArray objectAtIndex:indexPath.section - ADDED_CELL_ROWS];
            NSArray *array = [_dataDict objectForKey:cityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = FONT_14;
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            _hotCityCell = [tableView dequeueReusableCellWithIdentifier:@"HotCityCell"];
            if (_hotCityCell == nil) {
                _hotCityCell = [[MKHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" withCityArray:_hotCitiesArr];
            }
            _hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _hotCityCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
            NSString *cityKey = [_titleArray objectAtIndex:indexPath.section - 1];
            NSArray *array = [_dataDict objectForKey:cityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = FONT_14;
            return cell;
        }
    }
}

//右侧索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isAuthorized) {
        NSMutableArray *titleSectionArr = [NSMutableArray arrayWithObjects:@"定位",@"当前",@"热门",nil];
        for (int i=0; i<_titleArray.count; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",_titleArray[i]];
            [titleSectionArr addObject:title];
        }
        return titleSectionArr;
    }else{
        NSMutableArray *titleSectionArr = [NSMutableArray arrayWithObjects:@"当前",@"热门",nil];
        for (int i=0; i<_titleArray.count; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",_titleArray[i]];
            [titleSectionArr addObject:title];
        }
        return titleSectionArr;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 30)];
    label.font = FONT_14;
    [header addSubview:label];
    if (_isAuthorized) {
        if (section == 0) {
            label.text = @"定位";
        }else if (section == 1){
            label.text = @"热门城市";
        }else{
            label.text = _titleArray[section - ADDED_CELL_ROWS];
        }
    }else{
        if (section == 0) {
            label.text = @"热门城市";
        }else{
            label.text = _titleArray[section - 1];
        }
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAuthorized) {
        if (indexPath.section == 0) {
            return 42;
        }else if (indexPath.section == 1){
            return ceil((float)[_hotCitiesArr count] / 3) * (36 + 15) + 15;
        }else{
            return 42;
        }
    }else{
        if (indexPath.section == 0) {
            return ceil((float)[_hotCitiesArr count] / 3) * (36 + 15) + 15;
        }else{
            return 42;
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAuthorized) {
        if (indexPath.section == 1) {
            [(MKHotCityCell *)cell buttonClicked:^(UIButton *btn) {
               NSLog(@"%@",btn.titleLabel.text);
            }];
        }
    }else{
        if (indexPath.section == 0) {
            [(MKHotCityCell *)cell buttonClicked:^(UIButton *btn) {
                NSLog(@"%@",btn.titleLabel.text);
            }];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isAuthorized) {
        if (indexPath.section == 0) {
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"]);
        }else if (indexPath.section == 1){
            
        }else{
            NSString *cityKey = _titleArray[indexPath.section - ADDED_CELL_ROWS];
            NSArray *cityArr = _dataDict[cityKey];
            NSLog(@"%@",cityArr[indexPath.row]);
        }
    }else{
        if (indexPath.section == 0) {
            
        }else{
            NSString *cityKey = _titleArray[indexPath.section - 1];
            NSArray *cityArr = _dataDict[cityKey];
            NSLog(@"%@",cityArr[indexPath.row]);
        }
    }
}

@end
