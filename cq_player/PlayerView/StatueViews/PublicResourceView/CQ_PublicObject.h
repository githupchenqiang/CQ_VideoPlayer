//
//  CQ_PublicObject.h
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/11.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CQ_PublicObject : NSObject
+(void)showTipAlertViewWith:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
                   DalyTime:(CGFloat)DalyTime;


+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 CancleTitle:(NSString *)CancleTitle
                   downTitle:(NSString *)DownTitle
                CancelButton:(void (^)(void))cancleButton
                  DownButton:(void (^)(void))DownButton;
@end
