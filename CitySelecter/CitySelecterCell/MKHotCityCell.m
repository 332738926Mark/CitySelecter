//
//  MKHotCityCell.m
//  CitySelecter
//
//  Created by shendan on 16/12/19.
//  Copyright © 2016年 Mark. All rights reserved.
//

#define BUTTON_WIDTH ((SCREEN_WIDTH - 90) / 3)
#define BUTTON_HIEGHT 36
#define MARGIN 15

#import "MKHotCityCell.h"

@implementation MKHotCityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCityArray:(NSArray *)cities
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initButtonWithArrays:cities];

    }
    return self;
}

-(void)initButtonWithArrays:(NSArray *)cities
{
    if (cities.count > 0) {
        for (int i = 0; i<cities.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(MARGIN+(i%3)*(BUTTON_WIDTH+MARGIN), MARGIN+(i/3)*(MARGIN+BUTTON_HIEGHT), BUTTON_WIDTH, BUTTON_HIEGHT);
            [button setTitle:cities[i] forState:UIControlStateNormal];
            button.titleLabel.font = FONT_14;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.alpha = 0.8;
            button.layer.borderWidth = 1;
            button.layer.borderColor = RGBACOLOR(237, 237, 237, 1).CGColor;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
    }
}

-(void)buttonClick:(UIButton *)btn
{
    if (self.hotCityBtnClick) {
        self.hotCityBtnClick(btn);
    }
}

-(void)buttonClicked:(void (^)(UIButton *))block
{
    self.hotCityBtnClick = block;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
