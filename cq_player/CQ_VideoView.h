//
//  CQ_VideoView.h
//  cq_player
//
//  Created by QAING CHEN on 17/6/14.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CQ_VideoView : UIView
@property (nonatomic,strong)AVPlayer                *Player;
@property (nonatomic ,strong)AVPlayerItem           *PlayerItem;
@property (nonatomic ,strong)AVPlayerLayer          *PlayerLayer;
@property (nonatomic ,strong)id                     timeObser;
@property (nonatomic ,assign) float                 videoLength;
@end

@interface CQ_VideoView (gesture)
- (void)addSwipeView;

@end
