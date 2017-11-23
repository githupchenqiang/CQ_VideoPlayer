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

typedef enum {
    FillScreenType,
    PortraitScreen
}ScreenType;

typedef enum  {
    ChangeNone,
    ChangeVoice,
    ChangeLigth,
    ChangeCMTime
}Change;

@protocol cq_videoViewDelegate <NSObject>

/** slider的点击事件（点击slider控制进度） */
- (void)zf_controlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** 开始触摸slider */
- (void)zf_controlView:(UIView *)controlView progressSliderTouchBegan:(UISlider *)slider;
/** slider触摸中 */
- (void)zf_controlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)zf_controlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;
@end

@interface CQ_VideoView ()<cq_videoStatuesDelegate,UIGestureRecognizerDelegate>
/** 判断是否结束本次平移*/
@property (nonatomic,assign)BOOL                            isFinished;
@property (nonatomic ,strong)UIPanGestureRecognizer         *PanGesture;
@property (nonatomic ,strong)UIView                         *darkView;
@property (nonatomic ,assign) Change                        changeKind;
@property (nonatomic ,assign)ScreenType                     ScreenType;
@property (nonatomic ,assign)CGPoint                        lastPoint;
@property (nonatomic ,strong)MPVolumeView                   *volumeView;
@property (nonatomic ,strong)UISlider                       *volumeSlider;
@property (nonatomic ,assign)BOOL                           isStop;
@property (nonatomic ,strong)UIActivityIndicatorView                     *activity;
/** 状态button */
@property (nonatomic ,strong)UIButton                       *statuebutton;
/** 描述文字 */
@property (nonatomic ,strong)NSString                       *desTitle;
/** 是否暂停 */
@property (nonatomic ,assign)BOOL                           isPause;
/** 滑杆 */
@property (nonatomic, strong) UISlider                      *volumeViewSlider;
/** 声明状态view */
@property (nonatomic ,strong)cq_VideoStatues                *statuesView;
/**快进的总时常*/
@property (nonatomic ,assign)CGFloat                       sumTime;
/** 记录移动的时间 */
@property (nonatomic ,assign)CGFloat                        seekTime;
/** 是否全屏 */
@property (nonatomic ,assign)BOOL                           isFullScreen;
/** 是否正在拖拽 */
@property (nonatomic, assign) BOOL                          isDragged;
/** 视频播放地址 */
@property (nonatomic ,strong)NSString                       *VideoUrl;
/** 全屏按钮*/
@property (nonatomic ,strong)UIButton                       *ScreenButton;
/** slider上次的值 */
@property (nonatomic, assign)CGFloat                        sliderLastValue;
/** 是否是设置声音*/
@property (nonatomic ,assign)BOOL                            isVolume;

@property (nonatomic ,assign)id<cq_videoViewDelegate>delegate;
@end



@implementation CQ_VideoView

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString *)UrlString Title:(NSString *)Title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        _desTitle = Title;
        _VideoUrl = UrlString;
        [self setPlayerWithUrl:UrlString];
        [self addTopView];
        [self addNotifications];
       
    }
    return self;
}

- (void)addNotifications
{
    //检测耳机拔出事件
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
}



- (void)addTopView
{
    _statuesView = [[cq_VideoStatues alloc]initWithFrame:CGRectZero];
    _statuesView.delegate = self;
    _statuebutton = _statuesView.StarButton;
    _statuesView.Titlelabel.text = _desTitle;
    _statuesView.backgroundColor = [UIColor clearColor];
    [self addSubview:_statuesView];
    [_statuesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addSubview:self.activity];
    [self.activity startAnimating];
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:_VideoUrl]];
    CGFloat time = asset.duration.value / asset.duration.timescale;
        _statuesView.TotalHour = time;
    //这里计算总时长有两种方法都可以计算视屏总时长
    /*
    NSString *string = [NSString stringWithFormat:@"%f",time - (8 * 60 * 60)]; //这里-后面的不知道为什么,不减就会多出8小时
        NSTimeInterval createTime = [string longLongValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"h:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:createTime];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        _statuesView.TotalTime.text = confromTimespStr;
    */
    int minute = 0;
    int index = 0;
    if (time >= 60) {
        index  = time / 60;
        minute = index % 60;
        time = time - index*60;
}
    NSInteger hour = index/60;
    NSString *totalstring = [NSString stringWithFormat:@"%ld:%d:%.f",(long)hour,minute,time];
    _statuesView.TotalTime.text = totalstring;
        
    });
}

//构建播放器
- (void)setPlayerWithUrl:(NSString *)UrlString
{
    //给view添加手势,控制音量加减
    UISwipeGestureRecognizer *pan = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(PanAction:)];
    [pan setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:pan];
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:UrlString]];
    _PlayerItem = [[AVPlayerItem alloc]initWithAsset:asset];
    _Player = [AVPlayer playerWithPlayerItem:_PlayerItem];
    _PlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_Player];
    _PlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.layer addSublayer:_PlayerLayer];
    [self addVideoKVO];
    [self addVideoTimerObserver];
    [self sizebuff];
    // 获取系统音量
    [self configureVolume];
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

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
//    self.isVolume ? (self.volumeViewSlider.value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    NSLog(@"=======");
    self.sumTime += value / 500;
//     需要限定sumTime的范围
    CMTime totalTime           = self.PlayerItem.duration;
    CGFloat totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    BOOL style = false;
    if (value > 0) { style = YES; }
    if (value < 0) { style = NO; }
    if (value == 0) { return; }
    self.isDragged = YES;
}




/**缓冲进度 */
- (void)sizebuff{
NSTimeInterval timeInterval = [self availableDuration];

CMTime duration11 = self.PlayerItem.duration;
CGFloat totalDuration = CMTimeGetSeconds(duration11);
    NSLog(@"===******====%f",timeInterval / totalDuration);
}
// 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.Player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:)name:AVPlayerItemDidPlayToEndTimeNotification object:self.PlayerItem];
}

- (void)removeVideoKVO {
    [_PlayerItem removeObserver:self forKeyPath:@"status"];
    [_PlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_PlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

/**
 播放完成

 @param notice notice
 */
- (void)playerItemDidReachEnd:(NSNotification *)notice
{
    _statuebutton.selected = NO;
    _statuesView.ReplayButton.hidden = NO;
    
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = _PlayerItem.status;
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
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        [self.statuesView.progressView setProgress:(timeInterval / self.statuesView.TotalHour) animated:YES];
        if (timeInterval > self.getCurrentPlayingTime+5){ // 缓存 大于 播放 当前时长+5
            if (_isPause == NO) { // 接着之前 播放时长 继续播放
                [self.Player play];
                [_activity stopAnimating];
                _statuebutton.selected = YES;
                self.isPause = YES;
            }
        }else{
            _isPause = NO;
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
    }
}
- (double)getCurrentPlayingTime{
    return self.Player.currentTime.value/self.Player.currentTime.timescale;
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


#pragma mark - TimerObserver
- (void)addVideoTimerObserver {
    __weak typeof (self)self_ = self;
    _timeObser = [_Player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//        float currentTimeValue = time.value*1.0/time.timescale/self_.videoLength;
        NSString *currentString = [self_ getStringFromCMTime:time];
        
        NSLog(@"===%f",self_.videoLength);
        self_.statuesView.CurrentTime.text = currentString;
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
    _statuesView.CurrentHour = currentTimeValue;
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


#pragma mark===cq_videoStatuesDelegate====
- (void)cq_videoBackview
{
    if (_isFullScreen) {
        _isFullScreen = NO;
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        _ScreenButton.selected = NO;
        
    }else
    {
    [self.Player pause];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

-(void)cq_videoFillScreenWindowWithbutton:(UIButton *)button
{
    button.selected = !button.selected;
    _ScreenButton = button;
    if (button.selected) {
     [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else
    {
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

/**
 快进后退

 @param slider sliderValue
 */
-(void)cq_VideoChangeSlider:(UISlider *)slider
{
    CGFloat total = (CGFloat)self.PlayerItem.duration.value / self.PlayerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * slider.value);
    if (self.Player.status == AVPlayerItemStatusReadyToPlay) {
        [self.Player pause];
        CMTime DragedTime = CMTimeMake(dragedSeconds, 1);
        [self.Player seekToTime:DragedTime toleranceBefore:CMTimeMake(1, 1) toleranceAfter:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            [self.Player play];
            _statuebutton.selected = YES;
           
        }];
    }
}

- (void)cq_videoClickbuttonActionWith:(UIButton *)button
{
    button.selected =!button.selected;
    if (button.selected) {
        [_Player play];
        _isPause = NO;
    }else
    {
        [_Player pause];
        _isPause = YES;
    }
}

- (void)cq_videoReplayButtonActionWith:(UIButton *)button WithTagNumber:(NSNumber *)number
{
    NSInteger tagNumber = [number integerValue];
    switch (tagNumber) {
        case 0:
            [self seekValue:0];
            [_Player play];
            button.hidden = YES;
            _activity.hidden = NO;
            [_activity startAnimating];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}


- (void)stopVideo
{
    if (!_isPause) {
        [_Player pause];
        _isPause = YES;
        _statuebutton.selected = NO;
    }else{
        [_Player play];
        _isPause = NO;
        _statuebutton.selected = YES;
    }
}

/**
 滑动快进,声音加减

 @param pangesture 手势
 */
-(void)pangestureActionWith:(UIPanGestureRecognizer *)pangesture
{
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pangesture locationInView:self];
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pangesture velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pangesture.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                // 给sumTime初值
                CMTime time       = self.Player.currentTime;
                self.sumTime      = time.value / time.timescale;
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                                        self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                                        self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                    
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    //                    self.isPauseByUser = NO;
                                        [self seekToTime:self.sumTime completionHandler:nil];
                    // 把sumTime滞空，不然会越加越多
                    //                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    //                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)seekToTime:(CGFloat )time completionHandler:(void(^)(BOOL finished))completionHandler
{
    CGFloat total = (CGFloat)self.PlayerItem.duration.value / self.PlayerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = time;
    if (self.Player.status == AVPlayerItemStatusReadyToPlay) {
        [self.Player pause];
        CMTime DragedTime = CMTimeMake(dragedSeconds, 1);
        [self.Player seekToTime:DragedTime toleranceBefore:CMTimeMake(1, 1) toleranceAfter:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            [self.Player play];
            _statuebutton.selected = YES;
            
        }];
    }
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}


/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    
    [self addPlayerToFatherView:_fatherView];
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}


- (void)addPlayerToFatherView:(UIView *)view {
    [self removeFromSuperview];
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
}

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}


- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            [[UIApplication sharedApplication].keyWindow insertSubview:self belowSubview:self.statuesView];
            [self  mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                 make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    [self.statuesView layoutIfNeeded];
    [self.statuesView setNeedsLayout];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}


/**
 *  获取系统音量
 */
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryPlayback
                    error: &setCategoryError];
    
    if (!success) { /* handle the error in setCategoryError */ }
    // 监听耳机插入和拔掉通知
}

/**
 *  耳机插入、拔出事件
 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [_Player play];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}


- (ASValueTrackingSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
        _videoSlider.popUpViewCornerRadius = 0.0;
        _videoSlider.popUpViewColor =  [UIColor colorWithRed:19/255.0 green:19/255.0 blue:9/255.0 alpha:1];
        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:SetImage(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = setTextColor(@"#de4f4f");
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        
        UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:sliderTap];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
}


- (void)progressSliderTouchBegan:(ASValueTrackingSlider *)sender {
//    [self zf_playerCancelAutoFadeOutControlView];
    self.videoSlider.popUpView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchBegan:)]) {
        [self.delegate zf_controlView:self progressSliderTouchBegan:sender];
    }
}

- (void)progressSliderValueChanged:(ASValueTrackingSlider *)sender {
//    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderValueChanged:)]) {
//        [self.delegate zf_controlView:self progressSliderValueChanged:sender];
//    }

    //拖动改变视频播放进度
    if (self.Player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        self.isDragged = YES;
        BOOL style = false;
        CGFloat value = sender.value - self.sliderLastValue;
        if (value > 0) {style = YES;}
        if (value < 0) {style = NO;}
        if (value == 0) {return;}
        self.sliderLastValue = sender.value;
        
        CGFloat totaltime = (CGFloat)_PlayerItem.duration.value/_PlayerItem.duration.timescale;
        
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totaltime * sender.value);
        
        //转换成CMTime
        CMTime DragedCMTime = CMTimeMake(dragedSeconds, 1);
    }
}


- (void)progressSliderTouchEnded:(ASValueTrackingSlider *)sender {
//    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTouchEnded:)]) {
        [self.delegate zf_controlView:self progressSliderTouchEnded:sender];
    }
}


- (void)dealloc {
    NSLog(@"dealloc %@",NSStringFromSelector(_cmd));
    [self removeVideoTimerObserver];
    [self removeVideoNotic];
    [self removeVideoKVO];
}

- (void)removeVideoNotic {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemTimeJumpedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20,100,30,30
                                                                             )];
        _activity.activityIndicatorViewStyle =  UIActivityIndicatorViewStyleWhiteLarge;
        _activity.hidesWhenStopped = YES;
    }
    return _activity;
}

//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeVideoKVO];
    _Player = nil;
}


@end



