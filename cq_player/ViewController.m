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

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *URl = @"http://61.131.55.99/w/ca57fac6c78b5f4953d14627d4e2f3e4.mp4?type=m3u8.web.cloudplay&key=dadbd53a4bd3e090502b6ab54870bcb1";
    CQ_VideoView *video = [[CQ_VideoView alloc]initWithFrame:CGRectMake(0, 16, self.view.frame.size.width , self.view.frame.size.width * 9 / 16) Url:URl Title:@"新木乃伊"];
    video.backgroundColor = [UIColor blackColor];
    [self.view addSubview:video];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
