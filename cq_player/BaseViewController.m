//
//  BaseViewController.m
//  cq_player
//
//  Created by QAING CHEN on 17/6/15.
//  Copyright © 2017年 QiangChen. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewController.h"
@interface BaseViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView             *tabbale;
@property (nonatomic ,strong)NSArray                *dataArray;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabbale];
    _dataArray = @[@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
                   @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
                   @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                   @"http://baobab.wdjcdn.com/14525705791193.mp4",
                   @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                   @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                   @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                   @"http://baobab.wdjcdn.com/14564977406580.mp4",
                   @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                   @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                   @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                   @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                   @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                   @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                   @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                   @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                   @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *Control = [[ViewController alloc]init];
    Control.Url = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    [self presentViewController:Control animated:YES completion:nil];
}


-(UITableView *)tabbale
{
    if (!_tabbale) {
        _tabbale = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tabbale.delegate = self;
        _tabbale.dataSource = self;
        _tabbale.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        _tabbale.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        [_tabbale registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tabbale;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//支持旋转
-(BOOL)shouldAutorotate{
    return NO;
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
