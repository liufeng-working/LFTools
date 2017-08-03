//
//  LFBannerView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBannerView.h"
#import "LFBannerCell.h"
#import "LFBannerModel.h"
#import "LFExtraView.h"

#define kPageH 20 //UIPageControl高度
#define kExtraH 20 //标题，时间 view的高度
#define kTimeInterval 3 //轮播的时间
@interface LFBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) UICollectionView *collectionView;

@property(nonatomic,weak) UIPageControl *pageControl;

@property(nonatomic,strong) NSArray *priBanners;

@property(nonatomic,weak) NSTimer *timer;

@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,weak) LFExtraView *extraView;

@end

static NSString *const cellIdentifier = @"LFBannerCell";
@implementation LFBannerView

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kPageH, CGRectGetWidth(self.bounds), kPageH)];
        pageControl.hidesForSinglePage = YES;
        pageControl.numberOfPages = self.banners.count;
        pageControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (LFExtraView *)extraView
{
    if (!_extraView) {
        LFExtraView *extra = [[LFExtraView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kExtraH - kPageH, CGRectGetWidth(self.bounds), kExtraH)];
        [self addSubview:extra];
        _extraView = extra;
    }
    return _extraView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.collectionView registerClass:[LFBannerCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (void)setBanners:(NSArray<LFBannerModel *> *)banners
{
    _banners = banners;
    
    NSMutableArray *temArr = banners.mutableCopy;
    [temArr addObject:banners.firstObject];
    [temArr insertObject:banners.lastObject atIndex:0];
    self.priBanners = temArr;
    [self.collectionView reloadData];
    
    self.currentIndex = 1;
    [self changePositionAnimation:NO];
    [self changePage];
    
    [self fire];//开启定时器
}

#pragma mark -
#pragma mark - 开启定时器
- (void)fire
{
    if (!self.timer &&
        self.priBanners.count) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];//外界滚动时，定时器不会阻塞
    }
}

#pragma mark -
#pragma mark - 销毁定时器
- (void)invalidate
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -
#pragma mark - 定时器事件
- (void)handleTimer
{
    self.currentIndex ++;
    self.currentIndex %= self.priBanners.count;
    
    [self changePositionAnimation:YES];
    [self changePage];
}

#pragma mark -
#pragma mark - 改变位置
- (void)changePositionAnimation:(BOOL)animation
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animation];
}

#pragma mark -
#pragma mark - 改变显示标记
- (void)changePage
{
    LFBannerModel *model = self.priBanners[self.currentIndex];
    NSInteger index = [self.banners indexOfObject:model];
    self.pageControl.currentPage = index;
    
    if (model.title) {
        self.extraView.title = model.title;
    }
    
    if (model.time) {
        self.extraView.time = model.time;
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.priBanners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LFBannerModel *bannerModel = self.priBanners[indexPath.row];
    LFBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.bannerModel = bannerModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndex:bannerModel:)]) {
        [self.delegate bannerView:self didSelectItemAtIndex:indexPath.row bannerModel:self.priBanners[indexPath.row]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath.item;
    [self changePage];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = collectionView.indexPathsForVisibleItems.firstObject;//当前展示
    NSInteger index = currentIndexPath ? currentIndexPath.item : self.currentIndex;
    if (index == self.priBanners.count - 1) {
        self.currentIndex = 1;
    }else if (index == 0) {
        self.currentIndex = self.priBanners.count - 2;
    }else {
        self.currentIndex = index;
    }
    
    [self changePositionAnimation:NO];
    [self changePage];
}

#pragma mark -
#pragma mark - 拖动开始结束
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self fire];
}

@end
