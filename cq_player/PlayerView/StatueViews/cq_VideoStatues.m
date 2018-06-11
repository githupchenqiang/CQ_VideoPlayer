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
#import "BrightnessView.h"
#define ITEMS_HEIGHT  40



@implementation cq_VideoStatues

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SetUpViews];
        [self addSubViewsContraints];
    }
    return self;
}
- (void)SetUpViews{
    [self addSubview:self.TopView];
    [self.TopView needsUpdateConstraints];
    
    [self addSubview:self.BottomView];
    [self.BottomView needsUpdateConstraints];
    
    [self.TopView addSubview:self.BackButton];
    
    [self.TopView addSubview:self.Titlelabel];
    
    [self.BottomView addSubview:self.StarButton];
    
    [self.BottomView addSubview:self.CurrentTime];
    
    [self.BottomView addSubview:self.fillScreenButton];
    
    [self.BottomView addSubview:self.TotalTime];
    
    [self.BottomView addSubview:self.progressView];
    [self.progressView setNeedsUpdateConstraints];
    [self addSubview:self.FastTimelabel];
    
    [self.BottomView addSubview:self.Slider];
    [self.Slider setNeedsUpdateConstraints];
    
    [self addSubview:self.ReplayButton];
    
    _brightview = [[BrightnessView alloc]initWithType:BrightnessType];
    _brightview.hidden = YES;
    [self addSubview:_brightview];
    
    [self addSubview:self.LeftTimeImage];
    
    [self addSubview:self.RightTimeImage];
    
    [self addgesture];
    [_CurrentTime addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}



/**将状态view添加上*/
- (void)addSubViewsContraints{
    [self.TopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(0);
        make.left.mas_equalTo(self).offset(0);
        make.height.mas_equalTo(ITEMS_HEIGHT);
        Mas_Right(self, 0);
    }];
    
    [self.BottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self, 0);
        Mas_bottom(self, 0);
        make.top.mas_equalTo(self.mas_bottom).offset(-ITEMS_HEIGHT);
        Mas_Right(self, 0);
    }];
    
    [self.BackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.TopView).offset(5);
        make.centerY.mas_equalTo(self.TopView);
        Mas_height(ITEMS_HEIGHT);
    }];
    
    [self.Titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self.BackButton.mas_right, 10);
        make.centerY.mas_equalTo(self.TopView);
        make.right.mas_lessThanOrEqualTo(10);
    }];
    
    [self.StarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.BottomView);
        Mas_left(self.BottomView,0);
        Mas_Width(30);
        Mas_height(ITEMS_HEIGHT);
    }];
    
    [self.CurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self.StarButton.mas_right, 5);
        make.centerY.mas_equalTo(self.StarButton);
    }];
    
    [self.fillScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_Right(self.BottomView.mas_right,0);
        Mas_Top(self.BottomView, 0);
        Mas_bottom(self.BottomView, 0);
        Mas_Width(35);
    }];
    
    [self.TotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_Right(self.fillScreenButton.mas_left, 5);
        make.centerY.mas_equalTo(self.fillScreenButton);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self.StarButton.mas_right, 45);
        Mas_Right(self.TotalTime.mas_left, 4);
        Mas_height(2);
        make.centerY.mas_equalTo(self.BottomView);
    }];
    
    [self.Slider mas_makeConstraints:^(MASConstraintMaker *make) {
        Mas_left(self.progressView.mas_left,0);
        Mas_Right(self.TotalTime.mas_left, 4);
        make.centerY.mas_equalTo(self.BottomView);
        make.height.mas_equalTo(10);
    }];
    
    [self.ReplayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [self.LeftTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(30);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.RightTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-30);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.FastTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"]) {
        [self.Slider setValue:self.CurrentHour/self.TotalHour animated:YES];
        
    }
}


/** 添加手势*/
- (void)addgesture
{
    //添加单次点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
    
    //添加点击两次手势
    UITapGestureRecognizer *StopTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StopAction:)];
    StopTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:StopTap];
    //标识需要的stopTap检测失败才执行tap 否则执行stopTap
    [tap requireGestureRecognizerToFail:StopTap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
}

/**
 滑动手势

 @param pan <#pan description#>
 */
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    if ([_delegate respondsToSelector:@selector(pangestureActionWith:)]) {
        [_delegate pangestureActionWith:pan];
    }
}

- (void)StopAction:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(stopVideo)]) {
        [_delegate stopVideo];
    }
}

/**
 点击状态条消失
 @param tap  点击
 */
- (void)TapAction:(UITapGestureRecognizer *)tap
{
    if (!_isShowStatues) {
        _isShowStatues = YES;
        [UIView animateWithDuration:2.0f animations:^{
           [self.TopView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self).offset(-ITEMS_HEIGHT);
           }];
            
            [self.BottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                
                
                make.top.mas_equalTo(self.mas_bottom).offset(0);

            }];
             [self hidenViews];
        }];
    }else
    {
        _isShowStatues = NO;
            [self.TopView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).offset(0);
               
            }];
            [self.BottomView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self.mas_bottom).offset(-ITEMS_HEIGHT);
              [self ShowViews];
            }];
    }
}

- (void)hidenViews{
    _Slider.hidden = YES;
    _progressView.hidden = YES;
    _TotalTime.hidden = YES;
    _CurrentTime.hidden = YES;
    _StarButton.hidden = YES;
    _TopView.hidden = YES;
}

- (void)ShowViews{
    _Slider.hidden = NO;
    _progressView.hidden = NO;
    _TotalTime.hidden = NO;
    _CurrentTime.hidden = NO;
    _StarButton.hidden = NO;
    _TopView.hidden = NO;
}

//返回事件
- (void)BackAction:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(cq_videoBackview)]) {
        [_delegate cq_videoBackview];
    }
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
    _isSelect = !_isSelect;
    if ([_delegate respondsToSelector:@selector(cq_videoFillScreenWindowWithbutton:)]) {
        [_delegate cq_videoFillScreenWindowWithbutton:button];
    }
}


/**
 从新播放

 @param button button
 */
- (void)ReplayACtion:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(cq_videoReplayButtonActionWith:WithTagNumber:)]) {
        [_delegate cq_videoReplayButtonActionWith:button WithTagNumber:@0];
    }
}

/**
 sldier修改值

 @param paramSender slider
 */
-(void)SliderValueChange:(UISlider *)paramSender{
    if ([paramSender isEqual:self.Slider]) {
        if ([_delegate respondsToSelector:@selector(cq_VideoChangeSlider:)]) {
            [_delegate cq_VideoChangeSlider:paramSender];
        }
        [self.Slider setValue:paramSender.value animated:YES];
    }
}


//处理图片大小
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
#pragma mark ===懒加载UI控件====

- (UISlider *)Slider
{
    if (!_Slider) {
        _Slider = [[CQ_VideoSlider alloc]initWithFrame:CGRectZero];
        _Slider.minimumValue = 0.0;
        _Slider.maximumValue = 1.0;
        _Slider.value = 0.0;
        
        _Slider.backgroundColor = [UIColor clearColor];
        UIImage *image = [UIImage imageNamed:@"圆点"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_Slider setThumbImage:image forState:UIControlStateNormal];
        [_Slider addTarget:self action:@selector(SliderValueChange:) forControlEvents:UIControlEventTouchDragInside];
        _Slider.maximumTrackTintColor = [UIColor greenColor];
        _Slider.minimumTrackTintColor = UIColor.magentaColor;
        _Slider.continuous = NO;
    }
    return _Slider;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progress = 0.0;
        _progressView.progressTintColor = setTextColor(@"f4f4f4");
        _progressView.trackTintColor    = setTextColor(@"b3b3b3");
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0);
        _progressView.transform = transform;
        _progressView.backgroundColor = [UIColor redColor];
    }
    return _progressView;
}

-(UIButton *)ReplayButton
{
    if (!_ReplayButton) {
        _ReplayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ReplayButton setImage:SetImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
        _ReplayButton.hidden = YES;
        [_ReplayButton addTarget:self action:@selector(ReplayACtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ReplayButton;
}

-(UILabel *)TotalTime
{
    if (!_TotalTime) {
        _TotalTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _TotalTime.textColor = setTextColor(@"ffffff");
        _TotalTime.font = [UIFont systemFontOfSize:12];
    }
    return _TotalTime;
}

-(UILabel *)CurrentTime
{
    if (!_CurrentTime) {
        _CurrentTime = [[UILabel alloc]initWithFrame:CGRectZero];
        _CurrentTime.textColor = setTextColor(@"ffffff");
        _CurrentTime.font = [UIFont systemFontOfSize:12];
    }
    return _CurrentTime;
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
        _TopView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return  _TopView;
}


-(UIView *)BottomView
{
    if (!_BottomView) {
        _BottomView = [[UIView alloc]initWithFrame:CGRectZero];
        _BottomView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _BottomView;
}

-(UIImageView *)LeftTimeImage
{
    if (!_LeftTimeImage) {
        _LeftTimeImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _LeftTimeImage.image = SetImage(@"ZFPlayer_fast_backward@3x");
        _LeftTimeImage.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _LeftTimeImage.hidden = YES;
    }
    return _LeftTimeImage;
}

-(UIImageView *)RightTimeImage
{
    if (!_RightTimeImage) {
        _RightTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _RightTimeImage.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _RightTimeImage.image = SetImage(@"ZFPlayer_fast_forward@3x");
        _RightTimeImage.hidden = YES;
    }
    return _RightTimeImage;
}

-(UILabel *)FastTimelabel
{
    if (!_FastTimelabel) {
        _FastTimelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _FastTimelabel.textColor = UIColor.darkGrayColor;
        _FastTimelabel.font = [UIFont systemFontOfSize:16];
    }
    return _FastTimelabel;
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







-(void)dealloc
{
    [_CurrentTime removeObserver:self forKeyPath:@"text"];
}


@end
