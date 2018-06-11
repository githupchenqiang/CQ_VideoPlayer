# CQ_VideoPlayer
视屏播放器

*持续更新中,现在是是实现基础的播放功能,可以横竖屏切换,*
###使用方法,暂时不支持cocoapods的需要手动导入

**只需将工程cq_player文件夹导入您的项目中在需要播放视屏的地方加入下面的代码即可快速实现视屏播放的功能**


==*功能实现了全屏播放,视屏拖拽进度条实现快进与后退,功能持续更新,期待您的关注,觉得还可以记得给我star*==
***主要功能列表***
    1.拖拽进度条快进,后退
    2.左右滑动快进,后退
    3.方向锁,(默认在手机设置未锁定屏幕是,自动旋转屏幕,实现全屏或者竖屏播放自适应)
    4.全屏播放,可以主动点击按钮实现全屏播放
    5.左侧上下滑动实现亮度调剂,并有指示动画
    6.右侧上下滑动控制声音大小,
    
```
    NSString *URl = @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4";
    _video = [[CQ_VideoView alloc]initWithFrame:CGRectMake(0, 16, self.view.frame.size.width , self.view.frame.size.width * 9 / 16) Url:URl Title:@"电影名称"];
       
        //这个View大的大小要和你需要视屏大小一样大并且要赋值给CQ_VideoView的fatherView
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 16, self.view.frame.size.width , self.view.frame.size.width * 9 / 16)];
    [self.view addSubview:view];
    //这个father必须给,否则全屏返回会有问题
    _video.fatherView = view;
    _video.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_video];
```


```
//这个地方最好是是将view至为nil
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.video = nil;
}

```

![图片效果演示](https://github.com/githupchenqiang/CQ_VideoPlayer/raw/master/Untitled.gif)




