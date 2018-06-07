//
//  BrightnessView.h
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/7.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZLScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZLScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZLSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

typedef enum : NSUInteger {
    BrightnessType,
    VolumeType,
}promptViewType;


@interface BrightnessView : UIView

- (instancetype)initWithType:(promptViewType)type;
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel ;
@end
