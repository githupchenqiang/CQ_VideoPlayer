//
//  CQ_VideoSlider.m
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/8.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#import "CQ_VideoSlider.h"

@implementation CQ_VideoSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 10; //控制左边的距离
    rect.size.width = rect.size.width + 20; //控制右边的距离
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 10 , 10);
}

@end
