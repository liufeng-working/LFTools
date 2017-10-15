//
//  LFCollectionViewController.m
//  Demo
//
//  Created by NJWC on 2016/12/5.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFCollectionViewController.h"
#import "MJRefresh.h"

static NSString *systomCell = @"lf.systom.cell";
@interface LFCollectionViewController ()

@end

@implementation LFCollectionViewController

#pragma mark -
#pragma mark - 初始化资源数组
- (NSMutableArray *)collectionDataArr
{
    if (!_collectionDataArr) {
        _collectionDataArr = [NSMutableArray array];
    }
    return _collectionDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:systomCell];
    
    //默认有刷新控件
    self.refreshHeaderEnable = YES;
    self.refreshFooterEnable = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark - collection代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:systomCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.f, 50.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

#pragma mark -
#pragma mark - 添加上拉刷新
- (void)setRefreshHeaderEnable:(BOOL)refreshHeaderEnable
{
    _refreshHeaderEnable = refreshHeaderEnable;
    
    if (refreshHeaderEnable) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"释放立即刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
        self.collectionView.mj_header = header;
    }else {
        self.collectionView.mj_header = nil;
    }
}

#pragma mark -
#pragma mark - 添加下拉加载更多
- (void)setRefreshFooterEnable:(BOOL)refreshFooterEnable
{
    _refreshFooterEnable = refreshFooterEnable;
    
    if (refreshFooterEnable) {
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"释放立即加载更多" forState:MJRefreshStatePulling];
        [footer setTitle:@"正在加载更多..." forState:MJRefreshStateRefreshing];
        self.collectionView.mj_footer = footer;
    }else {
        self.collectionView.mj_footer = nil;
    }
}

#pragma mark -
#pragma mark - 上下拉刷新加载数据
- (void)refreshData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

- (void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer endRefreshing];
    });
}

@end
