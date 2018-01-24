
//
//  HFVideoPlayerControlView.m
//  HFVideoPlayer
//
//  Created by 皇坤鹏 on 2018/1/24.
//  Copyright © 2018年 皇坤鹏. All rights reserved.
//

#import "HFVideoPlayerControlView.h"

static const CGFloat kVideoControlBigPlayHeight = 60.0;
static const CGFloat kVideoControlBarHeight = 44.0;
static const CGFloat kVideoControlAnimationTimeInterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeInterval = 5.0;
static const CGFloat kVideoPlayerControllerAnimationTimeInterval = 0.3f;

@interface HFVideoPlayerControlView ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@end

@implementation HFVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.topBar];
        [self addSubview:self.closeButton];
        [self addSubview:self.bottomBar];
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.currentTimeLabel];
        [self.bottomBar addSubview:self.totalTimeLabel];
//        [self addSubview:self.coverImageView];
        [self addSubview:self.indicatorView];
        [self bringSubviewToFront:self.closeButton];
        
        self.pauseButton.hidden = YES;
        self.shrinkScreenButton.hidden = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
        [self configControlAction];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat topBarTop = self.isFullscreenMode ? CGRectGetMinY(self.bounds)+15 : CGRectGetMinY(self.bounds);
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), topBarTop, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.closeButton.frame = CGRectMake(0, topBarTop, CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.playButton.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
//    [self.playButton setCenter:self.center];
    self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.currentTimeLabel.frame = CGRectMake(0, 0, 60, CGRectGetHeight(self.bottomBar.bounds));
    self.totalTimeLabel.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds)-CGRectGetWidth(self.fullScreenButton.bounds)-60, 0, 60, CGRectGetHeight(self.bottomBar.bounds));
    self.progressSlider.frame = CGRectMake(CGRectGetWidth(self.currentTimeLabel.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2, CGRectGetWidth(self.bottomBar.bounds)-CGRectGetWidth(self.currentTimeLabel.bounds)-CGRectGetWidth(self.totalTimeLabel.bounds)-CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.progressSlider.bounds));
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.coverImageView.frame =CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide {
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.playButton.alpha = 0.0;
        self.pauseButton.alpha = 0.0;
        if (self.isFullscreenMode) {
            self.closeButton.alpha = 0.0;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
        }
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow {
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        self.playButton.alpha = 1.0;
        self.pauseButton.alpha = 1.0;
        if (self.isFullscreenMode) {
            self.closeButton.alpha = 1.0;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
        }
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar {
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}

- (void)cancelAutoFadeOutControlBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

- (void)configControlAction {
    [self.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)playButtonClick {
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidPlayClick:)]) {
        [self.delegate videoPlayerControlDidPlayClick:self];
    }
}

- (void)pauseButtonClick {
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidPauseClick:)]) {
        [self.delegate videoPlayerControlDidPauseClick:self];
    }
}

- (void)closeButtonClick {
    [self shrinkScreenButtonClick];
    if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidCloseClick:)]) {
        [self.delegate videoPlayerControlDidCloseClick:self];
    }
}

- (void)fullScreenButtonClick {
    if (self.isFullscreenMode) {
        return;
    }
    [self.superview bringSubviewToFront:self];
    self.isFullscreenMode = YES;
    self.originFrame = self.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.frame = frame;
        [self setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientationLandscapeRight) animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
        [self fullScreenToChangePlayButtonBounds];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
        self.fullScreenButton.hidden = YES;
        self.shrinkScreenButton.hidden = NO;
        if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidEnterFullScreenClick:)]) {
            [self.delegate videoPlayerControlDidEnterFullScreenClick:self];
        }
    }];
}

- (void)shrinkScreenButtonClick {
    if (!self.isFullscreenMode) {
        return;
    }
    
    self.isFullscreenMode = NO;
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        [self setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
        [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientationPortrait) animated:YES];
        [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleDefault)];
        [self fullScreenToChangePlayButtonBounds];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
        self.fullScreenButton.hidden = NO;
        self.shrinkScreenButton.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidShrinkFullScreenClick:)]) {
            [self.delegate videoPlayerControlDidShrinkFullScreenClick:self];
        }
    }];
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self cancelAutoFadeOutControlBar];
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    [self autoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(videoPlayerControlDidChangeProgressValue:)]) {
        [self.delegate videoPlayerControlDidChangeProgressValue:self];
    }
}

- (void)fullScreenToChangePlayButtonBounds {
    
    NSString *playImgName = self.isFullscreenMode ? [self videoImageName:@"hf-video-player-play-big"] : [self videoImageName:@"hf-video-player-play-small"];
    NSString *pauseImgName = self.isFullscreenMode ? [self videoImageName:@"hf-video-player-pause-big"] : [self videoImageName:@"hf-video-player-pause-small"];
    CGFloat playWH = self.isFullscreenMode ? kVideoControlBigPlayHeight : kVideoControlBarHeight;
    
    [_playButton setImage:[UIImage imageNamed:playImgName] forState:UIControlStateNormal];
    [_pauseButton setImage:[UIImage imageNamed:pauseImgName] forState:UIControlStateNormal];
    _playButton.bounds = CGRectMake(0, 0, playWH, playWH);
    _pauseButton.bounds = CGRectMake(0, 0, playWH, playWH);
    
    
}

#pragma mark ===== 全屏 or 小屏 =====
- (void)showInWindow {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {}];
}
- (void)showInView:(UIView *)view {
    
    [view addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeInterval animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark ===== 懒加载 =====
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        //设置开始和结束位置(设置渐变的方向)
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1);
        gradient.colors = colors;
        gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, kVideoControlBarHeight);
        [_bottomBar.layer insertSublayer:gradient atIndex:0];
        
    }
    return _bottomBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-play-small"]] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-pause-small"]] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-fullscreen"]] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton {
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-shrinkscreen"]] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-point"]] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor blueColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:[self videoImageName:@"hf-video-player-close"]] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _closeButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _totalTimeLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.backgroundColor = [UIColor cyanColor];
    }
    return _coverImageView;
}

#pragma mark - Private Method

- (NSString *)videoImageName:(NSString *)name {
    if (name) {
        NSString *path = [NSString stringWithFormat:@"HFVideoPlayerResource.bundle/%@",name];
        return path;
    }
    return nil;
}

@end
