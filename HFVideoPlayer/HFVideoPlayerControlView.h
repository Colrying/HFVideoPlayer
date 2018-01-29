//
//  HFVideoPlayerControlView.h
//  HFVideoPlayer
//
//  Created by 皇坤鹏 on 2018/1/24.
//  Copyright © 2018年 皇坤鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFVideoPlayerControlView;
@protocol HFVideoPlayerControlViewDelegate <NSObject>

@optional
- (void)videoPlayerControlDidCloseClick:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidPlayClick:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidPauseClick:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidEnterFullScreenClick:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidShrinkFullScreenClick:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidChangeProgressValue:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidChangeVolumeUp:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidChangeVolumeDown:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidChangeBrightnessUp:(HFVideoPlayerControlView *)videoPlayerController;
- (void)videoPlayerControlDidChangeBrightnessDown:(HFVideoPlayerControlView *)videoPlayerController;

@end

@interface HFVideoPlayerControlView : UIView

/**
 顶部导航条
 */
@property (nonatomic, strong, readonly) UIView *topBar;

/**
 底部导航条
 */
@property (nonatomic, strong, readonly) UIView *bottomBar;

/**
 播放按钮
 */
@property (nonatomic, strong, readonly) UIButton *playButton;

/**
 暂停按钮
 */
@property (nonatomic, strong, readonly) UIButton *pauseButton;

/**
 进入全屏按钮
 */
@property (nonatomic, strong, readonly) UIButton *fullScreenButton;

/**
 取消全屏按钮
 */
@property (nonatomic, strong, readonly) UIButton *shrinkScreenButton;

/**
 进度条
 */
@property (nonatomic, strong, readonly) UISlider *progressSlider;

/**
 关闭按钮（dismiss or pop）
 */
@property (nonatomic, strong, readonly) UIButton *closeButton;

/**
 播放时间标签
 */
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;

/**
 视频总时长标签
 */
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;

/**
 加载圈
 */
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;

/**
 展示图
 */
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, weak) id <HFVideoPlayerControlViewDelegate> delegate;

@property (nonatomic, copy) void (^closeHandle)(void);



- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;


- (void)showInWindow;
- (void)showInView:(UIView *)view;

@end
