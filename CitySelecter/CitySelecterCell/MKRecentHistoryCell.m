//
//  MKRecentHistoryCell.m
//  CitySelecter
//
//  Created by shendan on 2017/3/14.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import "MKRecentHistoryCell.h"

@interface MKRecentHistoryCell ()
@property (nonatomic, strong) NSMutableArray *currentCityArr;
@end


@implementation MKRecentHistoryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.firstButton];
        [self.contentView addSubview:self.secondButton];
        if ([self.currentCityArr count] > 1) {
            [self.firstButton setTitle:self.currentCityArr[0] forState:UIControlStateNormal];
            [self.secondButton setTitle:self.currentCityArr[1] forState:UIControlStateNormal];
        }else if ([self.currentCityArr count] > 0){
            [self.firstButton setTitle:self.currentCityArr[0] forState:UIControlStateNormal];
            [self.secondButton setHidden:YES];
        }
    }
    return self;
}

-(UIButton *)firstButton {
    if (_firstButton == nil) {
        _firstButton = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, Button_Width, Button_Height)];
        //[_firstButton setTitle:@"" forState:UIControlStateNormal];
        _firstButton.titleLabel.font = FONT_14;
        _firstButton.tintColor = [UIColor blackColor];
        _firstButton.backgroundColor = [UIColor whiteColor];
        _firstButton.layer.borderWidth = 1;
        _firstButton.layer.cornerRadius = 3;
        _firstButton.layer.borderColor = RGBACOLOR(237, 237, 237, 1).CGColor;
        [_firstButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}

-(UIButton *)secondButton {
    if (_secondButton == nil) {
        _secondButton = [[UIButton alloc] initWithFrame:CGRectMake(self.firstButton.frame.size.width+MARGIN*2, MARGIN, Button_Width, Button_Height)];
        //[_secondButton setTitle:@"" forState:UIControlStateNormal];
        _secondButton.titleLabel.font = FONT_14;
        _secondButton.tintColor = [UIColor blackColor];
        _secondButton.backgroundColor = [UIColor whiteColor];
        _secondButton.layer.borderWidth = 1;
        _secondButton.layer.cornerRadius = 3;
        _secondButton.layer.borderColor = RGBACOLOR(237, 237, 237, 1).CGColor;
        [_secondButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}

/*-(UIButton *)thirdButton {
    if (_thirdButton == nil) {
        _thirdButton = [[UIButton alloc] initWithFrame:CGRectMake(self.secondButton.frame.size.width +MARGIN*2, MARGIN, Button_Width, Button_Height)];
        _thirdButton.titleLabel.font = FONT_14;
        _thirdButton.tintColor = [UIColor blackColor];
        _thirdButton.backgroundColor = [UIColor whiteColor];
        _thirdButton.layer.borderWidth = 1;
        _thirdButton.layer.cornerRadius = 3;
        _thirdButton.layer.borderColor = RGBACOLOR(237, 237, 237, 1).CGColor;
        [_thirdButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdButton;
}*/

-(NSMutableArray *)currentCityArr {
    if (_currentCityArr == nil) {
        _currentCityArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserHistoryCity"];
    }
    return _currentCityArr;
}

#pragma mark - Event Response
- (void)buttonClick:(UIButton*)button{
    self.buttonClickBlock(button);
}

- (void)buttonWhenClick:(void (^)(UIButton *))block{
    self.buttonClickBlock = block;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
