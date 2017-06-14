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

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    CQ_VideoView *video = [[CQ_VideoView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width , 450)];
    video.backgroundColor = [UIColor blackColor];
    [self.view addSubview:video];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
