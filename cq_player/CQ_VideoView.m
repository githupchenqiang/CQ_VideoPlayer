//
//  CQ_VideoView.m
//  cq_player
//
//  Created by QAING CHEN on 17/6/14.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "CQ_VideoView.h"
#import <MediaPlayer/MPVolumeView.h>
#import "cq_VideoStatues.h"

typedef enum  {
    ChangeNone,
    ChangeVoice,
    ChangeLigth,
    ChangeCMTime
}Change;

@interface CQ_VideoView ()<cq_videoStatuesDelegate>

/** 判断是否结束本次平移*/
@property (nonatomic,assign)BOOL                            isFinished;
@property (nonatomic ,strong)UIPanGestureRecognizer         *PanGesture;
@property (nonatomic ,strong)UIView                         *darkView;
@property (nonatomic ,assign) Change                        changeKind;
@property (nonatomic ,assign)CGPoint                        lastPoint;
@property (nonatomic ,strong)MPVolumeView                   *volumeView;
@property (nonatomic ,strong)UISlider                       *volumeSlider;
@property (nonatomic ,strong)UISlider                       *videoSlider;
@property (nonatomic ,assign)BOOL                           isStop;
@property (nonatomic ,strong)UIActivityIndicatorView                     *activity;
@property (nonatomic ,strong)UIButton                       *statuebutton;
@property (nonatomic ,strong)NSString                       *desTitle;
@property (nonatomic ,strong)NSString                       *natureUrl;





@end



@implementation CQ_VideoView

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString *)UrlString Title:(NSString *)Title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        _desTitle = Title;
        _natureUrl = UrlString;
        [self setPlayer];
        [self addTopView];
       
    }
    return self;
}


- (void)addTopView
{
    cq_VideoStatues *statues = [[cq_VideoStatues alloc]initWithFrame:CGRectZero];
    statues.delegate = self;
    _statuebutton = statues.StarButton;
    statues.Titlelabel.text = _desTitle;
    statues.backgroundColor = [UIColor clearColor];
    [self addSubview:statues];
    [statues mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.activity];
    [self.activity startAnimating];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    
}

-(UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _activity.activityIndicatorViewStyle =  UIActivityIndicatorViewStyleWhiteLarge;
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}


//构建播放器
- (void)setPlayer
{
    //给view添加手势,控制音量加减
    UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PanAction:)];
    [pan setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:pan];
    
//    UITapGestureRecognizer *Pasuetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPause)];
//    Pasuetap.numberOfTapsRequired = 2;
//    [self addGestureRecognizer:Pasuetap];
    
    _PlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_natureUrl]];
    _Player = [AVPlayer playerWithPlayerItem:_PlayerItem];
    _PlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_Player];
    _PlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:_PlayerLayer];
//    [_Player play];
    [self addVideoKVO];
}

- (void)tapPause
{
//    if (_isStop) {
//        [_Player play];
//        _isStop = NO;
//    }else
//    {
//    [_Player pause];
//        _isStop = YES;
//    }
}


- (void)sliderValueChange:(UISlider *)slider
{
    [self seekValue:slider.value];
}


- (void)seekValue:(float)value {
    
    float toBeTime = value *_videoLength;
    [_Player seekToTime:CMTimeMake(toBeTime, 1) completionHandler:^(BOOL finished) {
        
        NSLog(@"seek Over finished:%@",finished ? @"success ":@"fail");
    }];
}

- (void)PanAction:(UISwipeGestureRecognizer *)pan
{
    if (pan.state == UISwipeGestureRecognizerDirectionUp) {
      NSLog(@"%ld",(long)pan.state);
    }
 
    [[UIScreen mainScreen] setBrightness:0.4];
}

- (void)commitTranslation:(CGPoint)translation
{
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    
    // 设置滑动有效距离
    if (MAX(absX, absY) < 1)
        
        return;
    
    if (absX > absY ) {
        
        if (translation.x<0) {
            NSLog(@"向左滑动");
            //向左滑动
        }else{
            
            NSLog(@"向右滑动");
            //向右滑动
        }
        
    } else if (absY > absX) {
        if (translation.y<0) {
            NSLog(@"向上滑动");
            //向上滑动
        }else{
            NSLog(@"向下滑动");
            //向下滑动
        }
    }
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _PlayerLayer.frame = self.bounds;
}

- (void)addVideoKVO
{
    //KVO
    [_PlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_PlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [_PlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeVideoKVO {
    [_PlayerItem removeObserver:self forKeyPath:@"status"];
    [_PlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_PlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = _PlayerItem.status;
        
        NSLog(@"%ld",status);
        
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                [_Player play];
                [_activity stopAnimating];
                _statuebutton.selected = YES;
//                _shouldFlushSlider = YES;
//                _videoLength = floor(_item.asset.duration.value * 1.0/ _item.asset.duration.timescale);
            }
                break;
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"AVPlayerItemStatusUnknown");
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"AVPlayerItemStatusFailed");
                NSLog(@"%@",_PlayerItem.error);
            }
                break;
                
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
    }
}


#pragma mark - Notic
- (void)addVideoNotic {
    
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieJumped:) name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStalle:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}


- (void)movieToEnd:(NSNotification *)notic {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)movieJumped:(NSNotification *)notic {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)movieStalle:(NSNotification *)notic {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)backGroundPauseMoive {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}


- (void)removeVideoNotic {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - TimerObserver
- (void)addVideoTimerObserver {
    __weak typeof (self)self_ = self;
    _timeObser = [_Player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        float currentTimeValue = time.value*1.0/time.timescale/self_.videoLength;
        NSString *currentString = [self_ getStringFromCMTime:time];
        
//        if ([self_.someDelegate respondsToSelector:@selector(flushCurrentTime:sliderValue:)] && _shouldFlushSlider) {
//            [self_.someDelegate flushCurrentTime:currentString sliderValue:currentTimeValue];
//        } else {
//            NSLog(@"no response");
//        }
    }];
}
- (void)removeVideoTimerObserver {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [_Player removeTimeObserver:_timeObser];
    _timeObser =  nil;
}


#pragma mark - Utils
- (NSString *)getStringFromCMTime:(CMTime)time
{
    float currentTimeValue = (CGFloat)time.value/time.timescale;//得到当前的播放时
    
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    
    if (currentTimeValue >= 3600 )
    {
        return [NSString stringWithFormat:@"%ld:%ld:%ld",components.hour,components.minute,components.second];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld:%ld",components.minute,components.second];
    }
}


- (NSString *)getVideoLengthFromTimeLength:(float)timeLength
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeLength];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    if (timeLength >= 3600 )
    {
        return [NSString stringWithFormat:@"%ld:%ld:%ld",components.hour,components.minute,components.second];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld:%ld",components.minute,components.second];
    }
}

- (void)cq_videoClickbuttonActionWith:(UIButton *)button
{
    button.selected =!button.selected;
    if (button.selected) {
        [_Player play];
    }else
    {
        [_Player pause];
    }
}



- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromSelector(_cmd));
    [self removeVideoTimerObserver];
    [self removeVideoNotic];
    [self removeVideoKVO];
}

@end


@implementation CQ_VideoView (gesture)

- (void)addSwipeView {
    _PanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [self addGestureRecognizer:_PanGesture];
    [self setUpDarkView];
}

- (void)setUpDarkView {
    _darkView = [[UIView alloc] init];
    [_darkView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_darkView setBackgroundColor:[UIColor blackColor]];
    _darkView.alpha = 0.0;
    [self addSubview:_darkView];
    
    NSMutableArray *darkArray = [NSMutableArray array];
    [darkArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_darkView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_darkView)]];
    [darkArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_darkView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_darkView)]];
    [self addConstraints:darkArray];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _changeKind = ChangeNone;
            _lastPoint = [gesture locationInView:self];
        }
            break;
        case  UIGestureRecognizerStateChanged:
        {
            [self getChangeKindValue:[gesture locationInView:self]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_changeKind == ChangeCMTime) {
                [self changeEndForCMTime:[gesture locationInView:self]];
            }
            _changeKind = ChangeNone;
            _lastPoint = CGPointZero;
        }
        default:
            break;
    }
    
}

- (void)getChangeKindValue:(CGPoint)pointNow {
    
    switch (_changeKind) {
            
        case ChangeNone:
        {
            [self changeForNone:pointNow];
        }
            break;
        case ChangeCMTime:
        {
            [self changeForCMTime:pointNow];
        }
            break;
        case ChangeLigth:
        {
            [self changeForLigth:pointNow];
        }
            break;
        case ChangeVoice:
        {
            [self changeForVoice:pointNow];
        }
            break;
            
        default:
            break;
    }
}

- (void)changeForNone:(CGPoint) pointNow {
    if (fabs(pointNow.x - _lastPoint.x) > fabs(pointNow.y - _lastPoint.y)) {
        _changeKind = ChangeCMTime;
    } else {
        float halfWight = self.bounds.size.width / 2;
        if (_lastPoint.x < halfWight) {
            _changeKind =  ChangeLigth;
        } else {
            _changeKind =   ChangeVoice;
        }
        _lastPoint = pointNow;
    }
}
- (void)changeForCMTime:(CGPoint) pointNow {
    float number = fabs(pointNow.x - _lastPoint.x);
    if (pointNow.x > _lastPoint.x && number > 10) {
        float currentTime = _Player.currentTime.value / _Player.currentTime.timescale;
        float tobeTime = currentTime + number*0.5;
        NSLog(@"forwart to  changeTo  time:%f",tobeTime);
    } else if (pointNow.x < _lastPoint.x && number > 10) {
        float currentTime = _Player.currentTime.value / _Player.currentTime.timescale;
        float tobeTime = currentTime - number*0.5;
        NSLog(@"back to  time:%f",tobeTime);
    }
}


- (void)changeForLigth:(CGPoint) pointNow {
    float number = fabs(pointNow.y - _lastPoint.y);
    if (pointNow.y > _lastPoint.y && number > 10) {
        _lastPoint = pointNow;
        [self minLigth];
        
    } else if (pointNow.y < _lastPoint.y && number > 10) {
        _lastPoint = pointNow;
        [self upperLigth];
    }
}


- (void)changeForVoice:(CGPoint)pointNow {
    float number = fabs(pointNow.y - _lastPoint.y);
    if (pointNow.y > _lastPoint.y && number > 10) {
        _lastPoint = pointNow;
        [self minVolume];
    } else if (pointNow.y < _lastPoint.y && number > 10) {
        _lastPoint = pointNow;
        [self upperVolume];
    }
}

- (void)changeEndForCMTime:(CGPoint)pointNow {
    if (pointNow.x > _lastPoint.x ) {
        NSLog(@"end for CMTime Upper");
        float length = fabs(pointNow.x - _lastPoint.x);
        [self upperCMTime:length];
    } else {
        NSLog(@"end for CMTime min");
        float length = fabs(pointNow.x - _lastPoint.x);
        [self mineCMTime:length];
    }
}

- (void)upperLigth {
    
    if (_darkView.alpha >= 0.1) {
        _darkView.alpha =  _darkView.alpha - 0.1;
    }
    
}
- (void)minLigth {
    if (_darkView.alpha <= 1.0) {
        _darkView.alpha =  _darkView.alpha + 0.1;
    }
}

- (void)upperVolume {
    if (self.volumeSlider.value <= 1.0) {
        self.volumeSlider.value =  self.volumeSlider.value + 0.1 ;
    }
    
}
- (void)minVolume {
    if (self.volumeSlider.value >= 0.0) {
        self.volumeSlider.value =  self.volumeSlider.value - 0.1 ;
    }
}


#pragma mark -CMTIME
- (void)upperCMTime:(float)length {
    
    float currentTime = _Player.currentTime.value / _Player.currentTime.timescale;
    float tobeTime = currentTime + length*0.5;
    if (tobeTime > _videoLength) {
        [_Player seekToTime:_PlayerItem.asset.duration];
    } else {
        [_Player seekToTime:CMTimeMake(tobeTime, 1)];
    }
}
- (void)mineCMTime:(float)length {
    
    float currentTime = _Player.currentTime.value / _Player.currentTime.timescale;
    float tobeTime = currentTime - length*0.5;
    if (tobeTime <= 0) {
        [_Player seekToTime:kCMTimeZero];
    } else {
        [_Player seekToTime:CMTimeMake(tobeTime, 1)];
    }
}

- (MPVolumeView *)volumeView {
    
    if (_volumeView == nil) {
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.hidden = YES;
        [self addSubview:_volumeView];
    }
    return _volumeView;
}

- (UISlider *)volumeSlider {
    if (_volumeSlider== nil) {
        NSLog(@"%@",[self.volumeView subviews]);
        for (UIView  *subView in [self.volumeView subviews]) {
            if ([subView.class.description isEqualToString:@"MPVolumeSlider"]) {
                _volumeSlider = (UISlider*)subView;
                break;
            }
        }
    }
    return _volumeSlider;
}


@end



