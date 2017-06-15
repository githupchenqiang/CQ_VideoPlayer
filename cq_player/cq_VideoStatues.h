//
//  cq_VideoStatues.h
//  cq_player
//
//  Created by QAING CHEN on 17/6/15.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cq_videoStatuesDelegate <NSObject>
- (void)cq_videoClickbuttonActionWith:(UIButton *)button;
- (void)cq_videoFillScreenWindowWithbutton:(UIButton *)button;
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
/**播放放置下方状态View*/
@property (nonatomic ,strong)UIView                     *BottomView;
/**获取Superview*/
@property (nonatomic ,strong)UIViewController           *viewController;
/**全屏*/
@property (nonatomic ,strong)UIButton                   *fillScreenButton;
/**是否显示上下状态栏*/
@property (nonatomic ,assign)BOOL                       isShowStatues;


/**声明代理Video*/
@property (nonatomic ,assign)id<cq_videoStatuesDelegate>delegate;


@end
