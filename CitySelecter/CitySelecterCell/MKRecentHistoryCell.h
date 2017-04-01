//
//  MKRecentHistoryCell.h
//  CitySelecter
//
//  Created by shendan on 2017/3/14.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKRecentHistoryCell : UITableViewCell

@property (strong, nonatomic) UIButton *firstButton;
@property (strong, nonatomic) UIButton *secondButton;
@property (strong, nonatomic) UIButton *thirdButton;

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *button);

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
