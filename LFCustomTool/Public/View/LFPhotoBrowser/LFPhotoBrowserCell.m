//
//  LFPhotoBrowserCell.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPhotoBrowserCell.h"
#import "LFPhotoModel.h"
#import "UIImageView+WebCache.h"

#define lfMinimumZoomScale 1
#define lfMaximumZoomScale 3
@interface LFPhotoBrowserCell ()<UIScrollViewDelegate>

@property(nonatomic,weak) UIImageView *imageView;

@property(nonatomic,weak) UIScrollView *scrollView;

@end

@implementation LFPhotoBrowserCell

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
        
        UIImageView *imageView = [[UIImageView alloc] init];
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
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    [self adjustFrame];
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self adjustFrame];
    }];
}

#pragma mark -
#pragma mark - 设置模型
- (void)setPhotoModel:(LFPhotoModel *)photoModel
{
    _photoModel = photoModel;

    //修改缩放比例
    self.scrollView.zoomScale = lfMinimumZoomScale;
    self.scrollView.contentOffset = CGPointZero;
    if (photoModel.image) {
        self.imageView.image = photoModel.image;
        [self adjustFrame];
    }else {
        [self.imageView sd_setImageWithPreviousCachedImageWithURL:photoModel.imgUrl placeholderImage:photoModel.placeholderImage options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self adjustFrame];
        }];
    }
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
    CGSize fitSize = [self fitSize:self.imageView.image.size maxSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds), MAXFLOAT)];
    self.scrollView.contentSize = fitSize;
    CGFloat fitW = fitSize.width;
    CGFloat fitH = fitSize.height;
    CGFloat fitX = [self fitOrigin:fitW max:CGRectGetWidth(self.scrollView.bounds)];
    CGFloat fitY = [self fitOrigin:fitH max:CGRectGetHeight(self.scrollView.bounds)];
    self.imageView.frame = CGRectMake(fitX, fitY, fitW, fitH);
}

- (CGSize)fitSize:(CGSize)originalSize maxSize:(CGSize)maxSize
{
    CGFloat maxW = maxSize.width;
    CGFloat maxH = maxSize.height;
    CGFloat maxScale = maxW*1.0/maxH;
    CGFloat originalW = originalSize.width;
    CGFloat originalH = originalSize.height;
    CGFloat scale = originalW*1.0/originalH;
    
    if (scale > maxScale && originalW > maxW) {
        return CGSizeMake(maxW, maxW / scale);
    }else if (scale < maxScale && originalH > maxH) {
        return CGSizeMake(scale * maxH, maxH);
    }else if (scale == maxScale && originalH > maxH) {
        return CGSizeMake(maxW, maxH);
    }else {
        return originalSize;
    }
}

- (CGFloat)fitOrigin:(CGFloat)original max:(CGFloat)max
{
    return original > max ? 0 : (max - original)*0.5;
}

@end
