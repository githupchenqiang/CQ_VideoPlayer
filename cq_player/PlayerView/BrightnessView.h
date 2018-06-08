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

//声音和亮度
typedef enum : NSUInteger {
    BrightnessType,
    VolumeType,
}promptViewType;


@interface BrightnessView : UIView


/**
 初始化

 @param type 选择type
 @return self
 */
- (instancetype)initWithType:(promptViewType)type;


/**
 设置指示的方块大小

 @param brightnessLevel 0-1
 */
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel ;
@end
