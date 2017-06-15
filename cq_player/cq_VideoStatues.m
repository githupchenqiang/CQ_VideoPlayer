//
//  cq_VideoStatues.m
//  cq_player
//
//  Created by QAING CHEN on 17/6/15.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "cq_VideoStatues.h"
#import "Masonry.h"
#import "UIColor+PYSearchExtension.h"

@implementation cq_VideoStatues

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self addSubviews];
    }
    return self;
}


/**将状态view添加上*/
- (void)addSubviews{
    [self addSubview:self.TopView];
    [self.TopView needsUpdateConstraints];
    [self.TopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(30);
        Mas_Right(self, 0);
    }];
    
    [self addSubview:self.BottomView];
    [self.BottomView needsUpdateConstraints];
    [self.BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self, 0);
        Mas_bottom(self, 0);
        Mas_height(30);
        Mas_Right(self, 0);
    }];
    
    
    [self.TopView addSubview:self.BackButton];
    [self.BackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.TopView).offset(5);
        make.centerY.mas_equalTo(self.TopView);
    }];
    
    
    [self.TopView addSubview:self.Titlelabel];
    [self.Titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self.BackButton.mas_right, 10);
        make.centerY.mas_equalTo(self.TopView);
        make.right.mas_lessThanOrEqualTo(10);
    }];
    
    
    [self.BottomView addSubview:self.StarButton];
    [self.StarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_bottom(self.BottomView, 0);
        Mas_left(self.BottomView, 5);
        Mas_Top(self.BottomView, 0);
    }];

    [self.BottomView addSubview:self.fillScreenButton];
    [self.fillScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_Right(self.BottomView.mas_right,5);
        Mas_Top(self.BottomView, 0);
        Mas_bottom(self.BottomView, 0);
    }];
    [self addgesture];
}

- (void)addgesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
}

- (void)TapAction:(UITapGestureRecognizer *)tap
{
    if (!_isShowStatues) {
        _isShowStatues = YES;
        [UIView animateWithDuration:2.0f animations:^{
           [self.TopView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self).offset(-25);
               make.left.mas_equalTo(self).offset(0);
               make.height.mas_equalTo(30);
               Mas_Right(self, 0);
               
           }];
            [self.BottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.mas_bottom).offset(0);
            }];
            
        }];
    }else
    {
        _isShowStatues = NO;
        
            [self.TopView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(0);
                make.left.mas_equalTo(self).offset(0);
                make.height.mas_equalTo(30);
                Mas_Right(self, 0);
            }];
        
        
            [self.BottomView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self.mas_bottom).offset(-30);
            }];
 
    }
    
}

//返回事件
- (void)BackAction:(UIButton *)btn
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

/**
 开始 /暂停
 @param button button
 */
- (void)StarAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cq_videoClickbuttonActionWith:)]) {
        [_delegate cq_videoClickbuttonActionWith:button];
    }
}



/**
 全屏 /最小
 @param button button
 */
- (void)ScreenAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cq_videoFillScreenWindowWithbutton:)]) {
        [_delegate cq_videoFillScreenWindowWithbutton:button];
    }
}


- (UIButton *)fillScreenButton
{
    if (!_fillScreenButton) {
        _fillScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fillScreenButton.frame = CGRectZero;
        [_fillScreenButton setImage:SetImage(@"ZFPlayer_shrinkscreen") forState:UIControlStateSelected];
        [_fillScreenButton setImage:SetImage(@"ZFPlayer_fullscreen@2x") forState:UIControlStateNormal];
        [_fillScreenButton addTarget:self action:@selector(ScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fillScreenButton;
}


-(UIButton *)StarButton
{
    if (!_StarButton) {
        _StarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_StarButton setImage:SetImage(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_StarButton setImage:SetImage(@"ZFPlayer_pause") forState:UIControlStateSelected];
        [_StarButton addTarget:self action:@selector(StarAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _StarButton;
}

-(UIButton *)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_BackButton addTarget:self action:@selector(BackAction:) forControlEvents:UIControlEventTouchUpInside];
        [_BackButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    }
    return _BackButton;
}

-(UILabel *)Titlelabel
{
    if (!_Titlelabel) {
        _Titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _Titlelabel.textColor = setTextColor(@"ffffff");
        _Titlelabel.text = @"";//@"发放八角咖啡吧尽快发把饭卡暴风科技安保费卡布发空间";
    }
    return _Titlelabel;
}

- (UIView *)TopView
{
    if (!_TopView) {
        _TopView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return  _TopView;
}


-(UIView *)BottomView
{
    if (!_BottomView) {
        _BottomView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _BottomView;
}

- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}




@end
