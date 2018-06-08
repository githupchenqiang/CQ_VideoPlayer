//
//  ViewController.m
//  cq_player
//
//  Created by QAING CHEN on 17/5/11.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CQ_VideoView.h"

@interface ViewController ()

@property (nonatomic,strong)AVPlayer                *Player;
@property (nonatomic ,strong)AVPlayerItem           *PlayerItem;
@property (nonatomic ,strong)AVPlayerLayer          *PlayerLayer;
@property (nonatomic ,strong)CQ_VideoView           *video;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    NSURL *URl = self.Url;
    //这个View大的大小要和你需要视屏大小一样大并且要赋值给CQ_VideoView的fatherView
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , self.view.frame.size.width * 9 / 16)];
    _video = [[CQ_VideoView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width , self.view.frame.size.width * 9 / 16) Url:URl Title:@"新木乃伊"];
    //这个father必须给,否则全屏返回会有问题
    _video.fatherView = view;
    _video.backgroundColor = [UIColor blackColor];
     [self.view addSubview:view];
    [self.view addSubview:_video];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.video = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
}


@end
