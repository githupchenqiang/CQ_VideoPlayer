//
//  CQ_VideoView.h
//  cq_player
//
//  Created by QAING CHEN on 17/6/14.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ASValueTrackingSlider.h"
#import "CQPlayerHeader.h"

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

@interface CQ_VideoView : UIView
@property (nonatomic,strong)AVPlayer                *Player;
@property (nonatomic ,strong)AVPlayerItem           *PlayerItem;
@property (nonatomic ,strong)AVPlayerLayer          *PlayerLayer;
@property (nonatomic ,strong)id                     timeObser;
@property (nonatomic ,assign) float                 videoLength;
@property (nonatomic ,strong)UIViewController       *viewController;
@property (nonatomic ,strong)UIView         *fatherView;
/**移动方向的枚举 */
@property (nonatomic ,assign)PanDirection               panDirection;

@property (nonatomic ,strong)ASValueTrackingSlider         *videoSlider;


- (instancetype)initWithFrame:(CGRect)frame Url:(NSURL *)Url Title:(NSString *)Title;
@end

@interface CQ_VideoView (gesture)
- (void)addSwipeView;

@end
