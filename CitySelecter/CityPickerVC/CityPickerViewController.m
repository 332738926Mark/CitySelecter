//
//  CityPickerViewController.m
//  CitySelecter
//
//  Created by shendan on 2017/3/31.
//  Copyright © 2017年 Mark. All rights reserved.
//

#define ADDED_CELL_ROWS 3

#import "CityPickerViewController.h"
#import "MKRecentHistoryCell.h"
#import "AnimationIndexView.h"
#import "LocationManager.h"
#import "ChineseToPinyin.h"
#import "MKHotCityCell.h"
#import "HXSearchBar.h"
#import "Masonry.h"

@interface CityPickerViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) NSMutableArray *searchResultsArr;
@property (strong, nonatomic) AnimationIndexView *indexView;
@property (strong, nonatomic) NSMutableArray *allCitiesArr;
@property (strong, nonatomic) MKHotCityCell *hotCityCell;
@property (strong, nonatomic) NSMutableArray *titleArr;
@property (strong, nonatomic) NSMutableArray *indexArr;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HXSearchBar *searchBar;
@property (strong, nonatomic) NSArray *hotCitiesArr;
@property (assign, nonatomic) BOOL isAuthorized;


@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[LocationManager sharedLocationManager] startLocation];
    _isAuthorized = [LocationManager sharedLocationManager].isAuthorizeOpenLocation;
    
    [self initData];
    [self setupTableView];
    [self setupIndexView];
    [self setupSearchBar];
}

-(void)initData {
    
    _hotCitiesArr = @[@"北京",@"深圳",@"上海",@"广州",@"香港",@"西安",@"珠海",@"湛江",@"佛山"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
    _dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    _allCitiesArr = [[NSMutableArray alloc] init];
    NSArray *allCityKeys = [_dataDict allKeys];
    for (int i=0; i<_dataDict.count; i++) {
        [_allCitiesArr addObjectsFromArray:_dataDict[allCityKeys[i]]];
    }
    
    _titleArr = [[NSMutableArray alloc] init];
    for (int i=0; i<26; i++) {
        //无i,o,u,v开头城市
        if (i == 8 || i == 14 || i == 20 || i == 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [_titleArr addObject:cityKey];
    }
    _indexArr = [[NSMutableArray alloc] initWithArray:_titleArr];
    [_indexArr insertObjects:@[@"定位",@"历史",@"热门"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    _searchResultsArr = [[NSMutableArray alloc] init];
}

-(void)setupSearchBar {
    _searchBar = [[HXSearchBar alloc] init];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    _searchBar.placeholder = @"输入城市名称或拼音查询";
    _searchBar.cursorColor = [UIColor grayColor];
    _searchBar.hideSearchBarBackgroundImage = YES;
    _searchBar.clearButtonImage = [UIImage imageNamed:@""];
    
    _searchBar.searchBarTextField.layer.cornerRadius = 4;
    _searchBar.searchBarTextField.layer.borderWidth = 1;
    _searchBar.searchBarTextField.layer.masksToBounds = YES;
    _searchBar.searchBarTextField.layer.borderColor = [UIColor grayColor].CGColor;
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(10+StatusBar_AND_NAV);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@35);
    }];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    _searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (self.searchResultsArr != nil) {
        [self.searchResultsArr removeAllObjects];
    }
    
    for (int i=0; i<_allCitiesArr.count; i++) {
        if ([[ChineseToPinyin pinyinFromChiniseString:_allCitiesArr[i]] hasPrefix:[searchString uppercaseString]] || [_allCitiesArr[i] hasPrefix:searchString]) {
            [self.searchResultsArr addObject:_allCitiesArr[i]];
        }
    }
    NSLog(@"%@",self.searchResultsArr);
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [self.view endEditing:YES];
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)setupTableView {
    UIView *fakeNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, StatusBar_AND_NAV)];
    fakeNav.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:fakeNav];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, StatusBar_Height, 44, 34)];
    closeButton.titleLabel.font = FONT_14;
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [fakeNav addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Verdana" size:15];
    titleLabel.text = @"城市选择";
    [fakeNav addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(fakeNav.mas_centerX);
        make.centerY.equalTo(closeButton.mas_centerY);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBar_AND_NAV + 55, SCREEN_WIDTH, Table_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)setupIndexView {
    _indexView = [[AnimationIndexView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25, StatusBar_AND_NAV+85, 25, Table_Height) indexArray:_indexArr];
    [self.view addSubview:_indexView];
    [_indexView selectIndexBlock:^(NSInteger section) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
    }];
}

-(void)closeButtonClick:(UIButton *)button {
    [self goBackViewController];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return _indexArr.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section < ADDED_CELL_ROWS) {
            return 1;
        }else{
            NSString *cityKey = _titleArr[section-ADDED_CELL_ROWS];
            NSArray *array = _dataDict[cityKey];
            return array.count;
        }
    }else {
        return self.searchResultsArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            UITableViewCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"location"];
            if (locationCell == nil) {
                locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"location"];
            }
            locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_isAuthorized) {
                locationCell.textLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"];
            } else {
                locationCell.textLabel.text = @"定位失败,请点击重试";
            }
            locationCell.textLabel.font = FONT_14;
            return locationCell;
            
        } else if (indexPath.section == 1) {
            MKRecentHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history"];
            if (cell == nil) {
                cell = [[MKRecentHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"history"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"UserHistoryCity"]) {
                cell.frame = CGRectMake(0, 0, 0, 0);
                [cell setHidden:YES];
            }
            return cell;
        } else if (indexPath.section == 2) {
            _hotCityCell = [tableView dequeueReusableCellWithIdentifier:@"HotCityCell"];
            if (_hotCityCell == nil) {
                _hotCityCell = [[MKHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"" withCityArray:_hotCitiesArr];
            }
            _hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _hotCityCell;
        }
        else {
            static NSString *identifier = @"cityPickerCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSString *cityKey = [_titleArr objectAtIndex:indexPath.section-ADDED_CELL_ROWS];
            NSArray *array = _dataDict[cityKey];
            cell.textLabel.text = array[indexPath.row];
            cell.textLabel.font = FONT_14;
            return cell;
        }

    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search"];
        }
        cell.textLabel.text = _searchResultsArr[indexPath.row];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left).offset(8);
        make.centerY.equalTo(header.mas_centerY);
    }];
    if (tableView == self.tableView) {
        label.text = _indexArr[section];
    }else {
        label.text = @"搜索结果";
    }
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 40;
        }else if (indexPath.section == 1){
            return Button_Height+30;
        }else if (indexPath.section == 2){
            return ceil((float)[_hotCitiesArr count] / 3) * (36 + 15) + 15;
        }else{
            return 40;
        }
    }else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 1) {
            [(MKRecentHistoryCell *)cell buttonWhenClick:^(UIButton *button) {
                self.pickedCityCallBack(button.titleLabel.text);
                [self savePickedCity:button.titleLabel.text];
                [self goBackViewController];
            }];
        }else if (indexPath.section == 2) {
            [(MKHotCityCell *)cell buttonClicked:^(UIButton *btn) {
                if(self.pickedCityCallBack){
                    self.pickedCityCallBack(btn.titleLabel.text);
                    [self savePickedCity:btn.titleLabel.text];
                    [self goBackViewController];
                }
            }];
        }
    }else {
        /*
        if(self.pickedCityCallBack){
            self.pickedCityCallBack(_searchResultsArr[indexPath.row]);
            [self savePickedCity:_searchResultsArr[indexPath.row]];
            [self goBackViewController];
        }*/
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            if (_isAuthorized) {
                if(self.pickedCityCallBack){
                    self.pickedCityCallBack([[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"]);
                    [self savePickedCity:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"]];
                    [self goBackViewController];
                }
            } else {
                NSLog(@"去设置");
            }
        }else if (indexPath.section == 1) {
            
        }else if (indexPath.section == 2) {
            
        }else {
            NSString *cityKey = _titleArr[indexPath.section - ADDED_CELL_ROWS];
            NSArray *cityArr = _dataDict[cityKey];
            if(self.pickedCityCallBack){
                self.pickedCityCallBack(cityArr[indexPath.row]);
                [self savePickedCity:cityArr[indexPath.row]];
                [self goBackViewController];
            }
        }
    }else {
        if(self.pickedCityCallBack){
            self.pickedCityCallBack(_searchResultsArr[indexPath.row]);
            [self savePickedCity:_searchResultsArr[indexPath.row]];
            [self goBackViewController];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//保存访问过的城市
- (void)savePickedCity:(NSString*)city{
    NSMutableArray *currentArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserHistoryCity"]];
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
    if ([currentArray count] < 2 && ![currentArray containsObject:city]) {
        [currentArray addObject:city];
    }else{
        if (![currentArray containsObject:city]) {
           // currentArray[2] = currentArray[1];
            currentArray[1] = currentArray[0];
            currentArray[0] = city;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentArray forKey:@"UserHistoryCity"];
}

-(void)goBackViewController {
    [self dismissViewControllerAnimated:UIViewAnimationTransitionCurlDown completion:nil];
}

@end
