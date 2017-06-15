//
//  BaseViewController.m
//  cq_player
//
//  Created by QAING CHEN on 17/6/15.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 70, 20)];
    label.text = @"播放";
    [self.view addSubview:label];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self presentViewController:[ViewController new] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
