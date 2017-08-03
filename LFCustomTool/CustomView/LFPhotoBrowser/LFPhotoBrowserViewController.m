//
//  LFPhotoBrowserViewController.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPhotoBrowserViewController.h"
#import "LFPhotoBrowserCell.h"
#import "LFTopView.h"
#import "LFBottomView.h"

@interface LFPhotoBrowserViewController ()<LFPhotoBrowserCellDelegate>

@property(nonatomic,weak) LFTopView *topView;
@property(nonatomic,weak) LFBottomView *bottomView;

@end

static NSString * const cellIdentifier = @"LFPhotoBrowserCell";
@implementation LFPhotoBrowserViewController

#pragma mark -
#pragma mark - 懒加载控件
- (LFTopView *)topView
{
    if (!_topView) {
        LFTopView *top = [[LFTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        top.totle = self.photos.count;
        [self.view addSubview:top];
        _topView = top;
    }
    return _topView;
}

- (LFBottomView *)bottomView
{
    if (!_bottomView) {
        LFBottomView *bottom = [[LFBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
        [self.view addSubview:bottom];
        _bottomView = bottom;
    }
    return _bottomView;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[LFPhotoBrowserCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    //移动到点击的图片
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    if (self.photos.count != 1) {
        self.topView.currentIndex = self.currentIndex + 1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

#pragma mark -
#pragma mark - 显示
- (void)show
{
    self.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.1 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [kWindow addSubview:self.view];
        [kWindow.rootViewController addChildViewController:self];
    }];
}

#pragma mark -
#pragma mark - 隐藏
- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LFPhotoModel *photoModel = self.photos[indexPath.row];
    LFPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.photoModel = photoModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = indexPath.item;
    self.topView.currentIndex = indexPath.row + 1;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = collectionView.indexPathsForVisibleItems.firstObject;
    self.currentIndex = indexPath.item;
    self.topView.currentIndex = currentIndexPath.row + 1;
}

#pragma mark -
#pragma mark - LFPhotoBrowserCellDelegate
- (void)didSelectPhotoBrowserCell:(LFPhotoBrowserCell *)cell
{
    [self hide];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    LFPhotoBrowserCell *item = (LFPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    [item playEnd];//开始拖拽，停止播放
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

@end
