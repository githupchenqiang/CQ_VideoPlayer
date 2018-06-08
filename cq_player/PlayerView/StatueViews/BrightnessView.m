//
//  BrightnessView.m
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/7.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#import "BrightnessView.h"

@interface BrightnessView ()

@property (nonatomic, strong) UIImageView        *backImage; //图片
@property (nonatomic, strong) UILabel            *title; //标题
@property (nonatomic, strong) UIView            *brightnessLevelView; //指示大小的方块
@property (nonatomic, strong) NSMutableArray    *tipArray; //所有方块的数组
@property (nonatomic, strong) UIImageView        *volumbackImage; //声音的图片
@property (nonatomic, strong) UILabel            *Volumtitle; //声音的文字

@end
@implementation BrightnessView
- (instancetype)initWithType:(promptViewType)type
{
    if (self = [super initWithFrame:CGRectZero]) {
        
        [self setUpUIWithType:type];
    }
    return  self;
}

- (void)setUpUIWithType:(promptViewType)type{
    self.frame = CGRectMake(ZLScreenWidth * 0.5 - 75, ZLScreenHeight * 0.5 - 75, 155, 155);
    self.layer.cornerRadius  = 10;
    self.layer.masksToBounds = YES;
    
    // 毛玻璃效果
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    [self addSubview:toolbar];
    
    switch (type) {
        case VolumeType:
            
            [self addSubview:self.Volumtitle];
            [self addSubview:self.volumbackImage];
            break;
            
            case BrightnessType:
            [self addSubview:self.backImage];
            [self addSubview:self.title];
            
            break;
        default:
            break;
    }
    [self addSubview:self.brightnessLevelView];
     [self createTips];
}

- (void)createTips {
    
    self.tipArray = [NSMutableArray arrayWithCapacity:16];
    CGFloat tipW = (self.brightnessLevelView.bounds.size.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i <16; i++) {
        CGFloat tipX   = i * (tipW + 1) + 1;
        UIImageView *image    = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame           = CGRectMake(tipX, tipY, tipW, tipH);
        [self.brightnessLevelView addSubview:image];
        [self.tipArray addObject:image];
    }
    [self updateBrightnessLevel:0];
}

//显示和隐藏方框
- (void)updateBrightnessLevel:(CGFloat)brightnessLevel{
    self.hidden = NO;
    CGFloat stage = 1 / 15.0;
    NSInteger level = brightnessLevel / stage;
    
        for (int i = 0; i < self.tipArray.count; i++) {
            UIImageView *img = self.tipArray[i];
            if (i <= level) {
              img.hidden = NO;
            }else
            {
               img.hidden = YES;
            }
        }
    }

#pragma mark - 懒加载
-(UILabel *)title {
    if (!_title) {
        _title   = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        _title.font  = [UIFont boldSystemFontOfSize:16];
        _title.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.text   = @"亮度";
    }
    return _title;
}

- (UIImageView *)backImage {
    
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 40,self.frame.size.height / 2 - 40, 79, 76)];
        _backImage.image  = [UIImage imageNamed:getResourceFromBundleFileName(@"brightness")];
    }
    return _backImage;
}


-(UILabel *)Volumtitle {
    if (!_Volumtitle) {
        _Volumtitle   = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 30)];
        _Volumtitle.font  = [UIFont boldSystemFontOfSize:16];
        _Volumtitle.textColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        _Volumtitle.textAlignment = NSTextAlignmentCenter;
        _Volumtitle.text   = @"音量";
    }
    return _Volumtitle;
}

- (UIImageView *)volumbackImage {
    
    if (!_volumbackImage) {
        _volumbackImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 40,self.frame.size.height / 2 - 40, 79, 76)];
        _volumbackImage.image  = [UIImage imageNamed:getResourceFromBundleFileName(@"音量")];
    }
    return _volumbackImage;
}


-(UIView *)brightnessLevelView {
    
    if (!_brightnessLevelView) {
        _brightnessLevelView  = [[UIView alloc]initWithFrame:CGRectMake(13, 132, self.bounds.size.width - 26, 7)];
        _brightnessLevelView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:1.00f];
        [self addSubview:_brightnessLevelView];
    }
    return _brightnessLevelView;
}

#pragma mark - 获取bundle资源
NSString* getResourceFromBundleFileName( NSString * filename) {
    NSString * vodPlayerBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"resource.bundle"] ;
    NSBundle *resoureBundle = [NSBundle bundleWithPath:vodPlayerBundle];
    
    if (resoureBundle && filename)
    {
        NSString * bundlePath = [[resoureBundle resourcePath ] stringByAppendingPathComponent:filename];
        
        return bundlePath;
    }
    return nil ;
}
@end
