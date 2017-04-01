//
//  AnimationIndexView.m
//  CitySelecter
//
//  Created by shendan on 2017/3/30.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import "AnimationIndexView.h"

@implementation AnimationIndexView

-(id)initWithFrame:(CGRect)frame indexArray:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.indexArray = [NSArray arrayWithArray:array];
        CGFloat indexLbaelHeight = (self.frame.size.height-119) / self.indexArray.count;
        
        for (int i=0; i<array.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i*indexLbaelHeight, self.frame.size.width, indexLbaelHeight)];
            label.text = self.indexArray[i];
            label.tag = TAG + i;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = STR_COLOR;
            label.font = FONT_SIZE;
            [self addSubview:label];
            
            _number = label.font.pointSize;
        }
    }
    return self;
}

#pragma mark AnimationWithSection

-(void)animationWithSection:(NSInteger)section {
    self.selectedBlock(section);
}

#pragma mark PanAnimationFinish

-(void)panAnimationFinish {
    CGFloat indexLbaelHeight = (self.frame.size.height-119) / self.indexArray.count;
    for (int i = 0; i < self.indexArray.count; i ++) {
        UILabel * label = (UILabel *)[self viewWithTag:TAG + i];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            label.center = CGPointMake(self.frame.size.width/2, i * indexLbaelHeight + indexLbaelHeight/2);
            label.font = FONT_SIZE;
            label.alpha = 1.0;
            label.textColor = STR_COLOR;
        }];
    }
    
    [UIView animateWithDuration:1 animations:^{
        
        //    self.animationLabel.alpha = 0;
        
    }];
}

#pragma mark PanAnimationBegin

-(void)panAnimationBeginWithToucher:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat indexLbaelHeight = (self.frame.size.height-119) / self.indexArray.count;
    
    for (int i = 0; i < self.indexArray.count; i ++) {
        UILabel * label = (UILabel *)[self viewWithTag:TAG + i];
        if (fabs(label.center.y - point.y) <= ANIMATION_HEIGHT){
            [UIView animateWithDuration:0.2 animations:^{
                
                label.center = CGPointMake(label.bounds.size.width/2 - sqrt(fabs(ANIMATION_HEIGHT * ANIMATION_HEIGHT - fabs(label.center.y - point.y) * fabs(label.center.y - point.y))), label.center.y);
                
                label.font = [UIFont systemFontOfSize:_number + (ANIMATION_HEIGHT - fabs(label.center.y - point.y)) * FONT_RATE];
                
                if (fabs(label.center.y - point.y) * ALPHA_RATE <= 0.08) {
                    label.textColor = MARK_COLOR;
                    label.alpha = 1.0;
                    
                    [self animationWithSection:i];
                    
                    for (int j = 0; j < self.indexArray.count; j ++) {
                        UILabel * label = (UILabel *)[self viewWithTag:TAG + j];
                        if (i != j) {
                            label.textColor = STR_COLOR;
                            label.alpha = fabs(label.center.y - point.y) * ALPHA_RATE;
                        }
                    }
                }
            }];
            
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                label.center = CGPointMake(self.frame.size.width/2, i * indexLbaelHeight + indexLbaelHeight/2);
                label.font = FONT_SIZE;
                label.alpha = 1.0;
            }];
        }
    }
}

#pragma mark UIResponder

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationBeginWithToucher:touches];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationBeginWithToucher:touches];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationFinish];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self panAnimationFinish];
}

-(void)selectIndexBlock:(selectedCallBack)block {
    self.selectedBlock = block;
}

-(void)dealloc {
    self.indexArray = nil;
    self.selectedBlock = nil;
}

@end
