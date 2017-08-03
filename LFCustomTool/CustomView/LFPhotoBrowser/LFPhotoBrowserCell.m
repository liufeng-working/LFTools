//
//  LFPhotoBrowserCell.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPhotoBrowserCell.h"
#import "LFPhotoModel.h"
#import "FLAnimatedImageView+WebCache.h"
#import "LFPhotoBrowserTool.h"

#define lfMinimumZoomScale 1
#define lfMaximumZoomScale 3
@interface LFPhotoBrowserCell ()<UIScrollViewDelegate>

@property(nonatomic,weak) FLAnimatedImageView *imageView;

@property(nonatomic,weak) UIScrollView *scrollView;

@property(nonatomic,weak) UIButton *playerBtn;

@property(nonatomic,weak) AVPlayer *player;

@property(nonatomic,weak) AVPlayerLayer *playerLayer;

@end

@implementation LFPhotoBrowserCell

#pragma mark -
#pragma mark - 懒加载控件
- (UIButton *)playerBtn
{
    if (!_playerBtn) {
        UIImage *normal = [UIImage imageNamed:@"lfPhotoBrowser_videoPlayer_normal"];
        UIImage *highlighted = [UIImage imageNamed:@"lfPhotoBrowser_videoPlayer_highlighted"];
        UIButton *player = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, normal.size.width, normal.size.height)];
        player.center = self.contentView.center;
        [player addTarget:self action:@selector(playerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [player setImage:normal forState:UIControlStateNormal];
        [player setImage:highlighted forState:UIControlStateHighlighted];
        [self.contentView addSubview:player];
        _playerBtn = player;
    }
    return _playerBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        scrollView.delegate = self;
        scrollView.minimumZoomScale = lfMinimumZoomScale;
        scrollView.maximumZoomScale = lfMaximumZoomScale;
        scrollView.bounces = NO;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.frame = self.scrollView.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        _imageView = imageView;
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2; //双击
        [_imageView addGestureRecognizer:doubleTapGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [self addGestureRecognizer:tapGesture];
        
        //注册播放视频结束后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark - 设置模型
- (void)setPhotoModel:(LFPhotoModel *)photoModel
{
    _photoModel = photoModel;

    //修改缩放比例
    self.scrollView.zoomScale = lfMinimumZoomScale;
    self.scrollView.contentOffset = CGPointZero;
    
    //去除播放视频的 layer
    [self playEnd];
    
    // 填充数据
    [self.imageView sd_setImageWithURL:photoModel.imgUrl placeholderImage:photoModel.placeholderImage options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [self adjustFrame];
    }];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat w = CGRectGetWidth(scrollView.bounds);
    CGFloat h = CGRectGetHeight(scrollView.bounds);
    CGFloat contentW = scrollView.contentSize.width;
    CGFloat contentH = scrollView.contentSize.height;
    self.imageView.center = CGPointMake(MAX(w, contentW)*0.5, MAX(h, contentH)*0.5);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self playerButtonHidden:YES];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self playerButtonHidden:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self playerButtonHidden:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self playerButtonHidden:NO];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self playerButtonHidden:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self playerButtonHidden:NO];
}

- (void)playerButtonHidden:(BOOL)hidden
{
    //1.视频
    //2.未播放
    if (self.photoModel.isVideo &&
        self.player.rate == 0) {
        self.playerBtn.hidden = hidden;
    }else {
        self.playerBtn.hidden = YES;
    }
}

#pragma mark -
#pragma mark - 双击
- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    if (self.scrollView.zoomScale == lfMaximumZoomScale) {
        [self.scrollView setZoomScale:lfMinimumZoomScale animated:YES];
    }else {
        CGPoint touchPoint = [tap locationInView:self.scrollView];
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

#pragma mark -
#pragma mark - 单击
- (void)handleTap
{
    if ([self.delegate respondsToSelector:@selector(didSelectPhotoBrowserCell:)]) {
        [self.delegate didSelectPhotoBrowserCell:self];
    }
}

#pragma mark -
#pragma mark - 调整坐标
- (void)adjustFrame
{
    CGSize fitSize = [LFPhotoBrowserTool fitSize:self.imageView.image.size maxSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), MAXFLOAT)];
    self.scrollView.contentSize = fitSize;
    CGFloat fitW = fitSize.width;
    CGFloat fitH = fitSize.height;
    CGFloat fitX = [LFPhotoBrowserTool fitOrigin:fitW max:CGRectGetWidth(self.scrollView.bounds)];
    CGFloat fitY = [LFPhotoBrowserTool fitOrigin:fitH max:CGRectGetHeight(self.scrollView.bounds)];
    self.imageView.frame = CGRectMake(fitX, fitY, fitW, fitH);
}

#pragma mark -
#pragma mark - 点击播放按钮
- (void)playerBtnClick:(UIButton *)sender
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.photoModel.videoUrl];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.imageView.bounds;
    [self.imageView.layer addSublayer:self.playerLayer];
    [self.player play];//播放
    [self playerButtonHidden:YES];
}

#pragma mark -
#pragma mark - 停止播放视频
- (void)playEnd
{
    [self.player pause];
    [self playerButtonHidden:NO];
    if (self.playerLayer)
        [self.playerLayer removeFromSuperlayer];
}

- (void)dealloc
{
    [self playEnd];
    //移除视频播放结束的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
