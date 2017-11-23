//
//  cq_VideoStatues.h
//  cq_player
//
//  Created by QAING CHEN on 17/6/15.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cq_videoStatuesDelegate <NSObject>
/**
 播放状态的Button事件
 @param button button
 */
- (void)cq_videoClickbuttonActionWith:(UIButton *)button ;
/**
 全屏事件
 
 @param button button
 */
- (void)cq_videoFillScreenWindowWithbutton:(UIButton *)button;

/**暂停事件*/
- (void)stopVideo;

- (void)cq_videoReplayButtonActionWith:(UIButton *)button WithTagNumber:(NSNumber *)number;

- (void)cq_VideoChangeSlider:(UISlider *)slider;

/**返回事件 */
- (void)cq_videoBackview;
-(void)pangestureActionWith:(UIPanGestureRecognizer *)pangesture;


@end

@interface cq_VideoStatues : UIView

/**返回按钮 */
@property (nonatomic ,strong)UIButton                   *BackButton;
/**标题label */
@property (nonatomic ,strong)UILabel                    *Titlelabel;
/**开始暂停按钮 */
@property (nonatomic ,strong)UIButton                   *StarButton;
/**放置上方状态View*/
@property (nonatomic ,strong)UIView                     *TopView;

//
/**播放放置下方状态View*/
@property (nonatomic ,strong)UIView                     *BottomView;
/**全屏*/
@property (nonatomic ,strong)UIButton                   *fillScreenButton;
/**当前播放时间 */
@property (nonatomic ,strong)UILabel                    *CurrentTime;
/**总时长 */
@property (nonatomic ,strong)UILabel                    *TotalTime;
//显示缓存状态
@property (nonatomic ,strong)UIProgressView             *progressView;
/**播放进度条 */
@property (nonatomic ,strong)UISlider                   *Slider;
/**视屏总时长 */
@property (nonatomic ,assign)CGFloat                    TotalHour;
/**当前时长 */
@property (nonatomic ,assign)CGFloat                    CurrentHour;
/**缓存时间 */
@property (nonatomic ,assign)CGFloat                    cacheTime;

/**重新播放 */
@property (nonatomic ,strong)UIButton                   *ReplayButton;
/**获取Superview*/
@property (nonatomic ,strong)UIViewController           *viewController;
/**是否显示上下状态栏*/
@property (nonatomic ,assign)BOOL                       isShowStatues;

@property (nonatomic ,assign)BOOL                       isSelect;





/**声明代理Video*/
@property (nonatomic ,assign)id<cq_videoStatuesDelegate>delegate;

@end
