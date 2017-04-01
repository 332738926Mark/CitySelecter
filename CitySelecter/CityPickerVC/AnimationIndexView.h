//
//  AnimationIndexView.h
//  CitySelecter
//
//  Created by shendan on 2017/3/30.
//  Copyright © 2017年 Mark. All rights reserved.
//

//字体变化率
#define FONT_RATE 1/8.000
//透明度变化率
#define ALPHA_RATE 1/80.0000
//初始状态索引颜色
#define STR_COLOR [UIColor grayColor]
//选中状态索引颜色
#define MARK_COLOR [UIColor orangeColor]
//初始状态索引大小
#define FONT_SIZE [UIFont systemFontOfSize:10]
//索引label的tag值(防止冲突)
#define TAG 233333
//圆的半径
#define ANIMATION_HEIGHT 80

#import <UIKit/UIKit.h>

typedef void(^selectedCallBack)(NSInteger );

@interface AnimationIndexView : UIView

/**
 *  动画视图(可自定义)
 */
//@property (nonatomic,strong) UILabel * animationLabel;

//索引数组
@property (nonatomic,strong) NSArray *indexArray;
//滑动回调block
@property (nonatomic,copy) selectedCallBack selectedBlock;
//初始数值(计算用到)
@property (nonatomic,unsafe_unretained) CGFloat number;

/**
 *  index滑动反馈
 */
-(void)selectIndexBlock:(selectedCallBack)block;

/**
 *  初始化
 */
- (instancetype)initWithFrame:(CGRect)frame indexArray:(NSArray *)array;

@end

