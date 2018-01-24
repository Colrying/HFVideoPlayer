//
//  ViewController.m
//  HFVideoPlayer
//
//  Created by 皇坤鹏 on 2018/1/24.
//  Copyright © 2018年 皇坤鹏. All rights reserved.
//

#import "ViewController.h"
#import "HFVideoPlayerControlView.h"

@interface ViewController () <HFVideoPlayerControlViewDelegate>
@property (nonatomic, strong) HFVideoPlayerControlView *videoPlay;
@property (nonatomic, strong) UIImageView *aView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    HFVideoPlayerControlView *videoPlay = [[HFVideoPlayerControlView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width*9/16)];
    videoPlay.delegate = self;
    videoPlay.currentTimeLabel.text = @"12:59:59";
    videoPlay.totalTimeLabel.text = @"12:59:59";
    [self.view addSubview:videoPlay];
    _videoPlay = videoPlay;
    
    UIImageView *aView = [[UIImageView alloc] init];
    aView.image = [UIImage imageNamed:@"16091G34I9-6.jpg"];
    aView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    aView.frame = CGRectMake(CGRectGetMinX(videoPlay.bounds), CGRectGetMinY(videoPlay.bounds), CGRectGetWidth(videoPlay.bounds), CGRectGetHeight(videoPlay.bounds));
    [videoPlay addSubview:aView];
    // 这两行代码使为了让aView随着videoPlay的变化而变化
    aView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    aView.contentMode = UIViewContentModeScaleAspectFit;
    // 让播放视频视图处于控制视图下方
    [videoPlay sendSubviewToBack:aView];
    _aView = aView;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    view.frame = CGRectMake(100, 400, 80, 80);
    [self.view addSubview:view];
    
}

- (void)videoPlayerControlDidCloseClick:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"关闭");
}
- (void)videoPlayerControlDidPlayClick:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"播放");
}
- (void)videoPlayerControlDidPauseClick:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"暂停");
}
- (void)videoPlayerControlDidEnterFullScreenClick:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"进入全屏");
    
}
- (void)videoPlayerControlDidShrinkFullScreenClick:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"取消全屏");
    
}
- (void)videoPlayerControlDidChangeProgressValue:(HFVideoPlayerControlView *)videoPlayerController {
    NSLog(@"改变进度");
}


- (BOOL)shouldAutorotate {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
