//
//  MKHotCityCell.h
//  CitySelecter
//
//  Created by shendan on 16/12/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^hotCityButtonClick)(UIButton *button);

@interface MKHotCityCell : UITableViewCell

/**
 *   热门城市选择回调
 */
@property (copy, nonatomic) hotCityButtonClick hotCityBtnClick;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCityArray:(NSArray *)cities;

-(void)buttonClicked:(void(^)(UIButton *btn))block;

@end
