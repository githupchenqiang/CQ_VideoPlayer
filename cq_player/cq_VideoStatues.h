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
- (void)cq_videoClickbuttonActionWith:(UIButton *)button;

/**
 全屏时间

 @param button button
 */
- (void)cq_videoFillScreenWindowWithbutton:(UIButton *)button;
/**暂停事件*/
- (void)stopVideo;

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


/**获取Superview*/
@property (nonatomic ,strong)UIViewController           *viewController;

/**是否显示上下状态栏*/
@property (nonatomic ,assign)BOOL                       isShowStatues;




/**声明代理Video*/
@property (nonatomic ,assign)id<cq_videoStatuesDelegate>delegate;

@end
