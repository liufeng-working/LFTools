//
//  LFShowPhotoView.m
//  KTUAV
//
//  Created by 刘丰 on 2017/9/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFShowPhotoView.h"
#import "LFShowPhotoCell.h"
#import "LFPhotoBrowserViewController.h"

static NSString *lf_showPhoto_Identifier = @"LFShowPhotoCell";
@interface LFShowPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) UICollectionView *collectionView;

@end

@implementation LFShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.delegate = self;
    collection.dataSource = self;
    collection.bounces = NO;
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    [self addSubview:collection];
    _collectionView = collection;
    [collection registerClass:[LFShowPhotoCell class] forCellWithReuseIdentifier:lf_showPhoto_Identifier];
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -
#pragma mark - 最大个数
- (NSUInteger)maxCount
{
    if ([self.dataSource respondsToSelector:@selector(maxCount:)]) {
        return [self.dataSource maxCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 列数
- (NSUInteger)columnCount
{
    if ([self.dataSource respondsToSelector:@selector(columnCount:)]) {
        return [self.dataSource columnCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 每个位置cell的size
- (CGSize)sizeAtIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(photoView:sizeAtIndex:)]) {
        return [self.dataSource photoView:self sizeAtIndex:index];
    }else {
        CGFloat itemW = (CGRectGetWidth(self.frame) - self.inset.left - self.inset.right - (self.columnCount - 1)*self.columnSpacing - 1)/self.columnCount;
        return CGSizeMake(itemW, itemW);
    }
}

#pragma mark -
#pragma mark - 上下左右间距
- (UIEdgeInsets)inset
{
    if ([self.dataSource respondsToSelector:@selector(insetInPhotoView:)]) {
        return [self.dataSource insetInPhotoView:self];
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark -
#pragma mark - 列间距
- (CGFloat)columnSpacing
{
    if ([self.dataSource respondsToSelector:@selector(columnSpacingInPhotoView:)]) {
        return [self.dataSource columnSpacingInPhotoView:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 行间距
- (NSUInteger)rowSpacing
{
    if ([self.dataSource respondsToSelector:@selector(rowSpacingInPhotoView:)]) {
        return [self.dataSource rowSpacingInPhotoView:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 数量
- (NSUInteger)count
{
    NSUInteger count = 0;
    if (self.images.count != 0) {
        count = self.images.count;
    }else if (self.urls.count != 0) {
        count = self.urls.count;
    }else if (self.items.count != 0) {
        count = self.items.count;
    }else {
        count = 0;
    }
    
    return count < self.maxCount ? count : self.maxCount;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFShowPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lf_showPhoto_Identifier forIndexPath:indexPath];
    if (self.images.count != 0) {
        cell.image = self.images[indexPath.row];
    }else if (self.urls.count != 0) {
        cell.url = self.urls[indexPath.row];
    }else if (self.items.count != 0) {
        if (self.item_map) {
            id item = self.item_map(self.items[indexPath.row]);
            if ([item isKindOfClass:[UIImage class]]) {
                cell.image = item;
            }else if ([item isKindOfClass:[NSURL class]]) {
                cell.url = item;
            }else {
                NSAssert(NO, @"block\"item_map\"的返回值应为UIImage或NSURL");
            }
        }else {
            NSAssert(NO, @"使用[LFShowPhotoView items]，必须实现\"item_map\"");
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(photoView:didSelectAtIndex:)]) {
        [self.delegate photoView:self didSelectAtIndex:indexPath.row];
    }else {
        
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self sizeAtIndex:indexPath.row];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.rowSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.columnSpacing;
}

@end
