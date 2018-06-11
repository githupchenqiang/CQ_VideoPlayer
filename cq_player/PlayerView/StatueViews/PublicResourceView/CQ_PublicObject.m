//
//  CQ_PublicObject.m
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/11.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#import "CQ_PublicObject.h"

@implementation CQ_PublicObject

+(void)showTipAlertViewWith:(UIViewController *)viewController
                      title:(NSString *)title
                    message:(NSString *)message
                   DalyTime:(CGFloat)DalyTime
{
    UIAlertController *Contr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [viewController presentViewController:Contr animated:YES completion:nil];
    [self performSelector:@selector(dismissAlertController:) withObject:Contr afterDelay:DalyTime];
}

+ (void)showTipAlertViewWith:(UIViewController *)viewController
                       title:(NSString *)title
                     message:(NSString *)message
                 CancleTitle:(NSString *)CancleTitle
                   downTitle:(NSString *)DownTitle
                CancelButton:(void (^)(void))cancleButton
                  DownButton:(void (^)(void))DownButton
{
    UIAlertController *Contr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:CancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancleButton();
    }];
    
    UIAlertAction *Down = [UIAlertAction actionWithTitle:DownTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DownButton();
    }];
    
    [Contr addAction:action];
    [Contr addAction:Down];
    [viewController presentViewController:Contr animated:YES completion:nil];
}

+ (void)dismissAlertController:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}
@end
