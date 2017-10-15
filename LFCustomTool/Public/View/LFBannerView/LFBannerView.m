//
//  LFBannerView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBannerView.h"
#import "LFBannerCell.h"
#import "LFBannerExtraView.h"

#define kPageH 30 //UIPageControl高度
#define kPageWper 20 //UIPageControl宽度
#define kExtraH 30 //标题，时间 view的高度
#define kTimeInterval 3 //轮播的时间
@interface LFBannerView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) UICollectionView *collectionView;

@property(nonatomic,weak) UIPageControl *pageControl;

@property(nonatomic,strong) NSArray *priBanners;

@property(nonatomic,weak) NSTimer *timer;

@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,weak) LFBannerExtraView *extraView;

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
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
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
        UIPageControl *pageControl = [[UIPageControl alloc] init];
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

- (LFBannerExtraView *)extraView
{
    if (!_extraView) {
        LFBannerExtraView *extra = [[LFBannerExtraView alloc] init];
        extra.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:extra];
        _extraView = extra;
    }
    return _extraView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[LFBannerCell class] forCellWithReuseIdentifier:cellIdentifier];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.collectionView.frame = self.bounds;
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize = CGSizeMake(width, height);
    NSUInteger count = self.banners.count;
    if (count == 1) {
        count = 0;
    }
    self.pageControl.frame = CGRectMake(width - count*kPageWper, height - kPageH, count*kPageWper, kPageH);
    self.pageControl.numberOfPages = count;
    self.extraView.frame = CGRectMake(0, height - kExtraH, width - count*kPageWper, kExtraH);
}

- (void)setBanners:(NSArray<LFBannerModel *> *)banners
{
    _banners = banners;
    
    NSMutableArray *temArr = banners.mutableCopy;
    [temArr addObject:banners.firstObject];
    [temArr insertObject:banners.lastObject atIndex:0];
    self.priBanners = temArr;
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentIndex = 1;
        [self changePositionAnimation:NO];
        [self changePage];
    });
    
    [self fire];//开启定时器
    
    [self setNeedsLayout];
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
