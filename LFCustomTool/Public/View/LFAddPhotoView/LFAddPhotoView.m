//
//  LFAddPhotoView.m
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFAddPhotoView.h"
#import "LFAddPhotoCell.h"
#import "LFPhotoBrowserViewController.h"

#define lf_addPhoto_count self.photos.count

static NSString *lf_addPhoto_Identifier = @"LFAddPhotoCell";
@interface LFAddPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LFAddPhotoCellDelegate>

@property(nonatomic,weak) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray<UIImage *> *photos;
@property(nonatomic,strong,readwrite) NSMutableArray<UIImage *> *images;

@end

@implementation LFAddPhotoView

- (NSMutableArray<UIImage *> *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray<UIImage *> *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupDefault];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
    [self setupDefault];
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
    [collection registerClass:[LFAddPhotoCell class] forCellWithReuseIdentifier:lf_addPhoto_Identifier];
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setupDefault
{
    [self.photos addObject:self.addImage];
}

#pragma mark -
#pragma mark - 添加一张图
- (void)addImage:(UIImage *)image
{
    [self.photos removeLastObject];
    [self.photos addObject:image];
    [self.photos addObject:self.addImage];
    [self.collectionView reloadData];
    [self.images addObject:image];
}

#pragma mark -
#pragma mark - 添加多张图
- (void)addImages:(NSArray<UIImage *> *)images
{
    [self.photos removeLastObject];
    [self.photos addObjectsFromArray:images];
    [self.photos addObject:self.addImage];
    [self.collectionView reloadData];
    [self.images addObjectsFromArray:images];
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
#pragma mark - 添加按钮的图片
- (UIImage *)addImage
{
    if ([self.dataSource respondsToSelector:@selector(addImageInPhotoView:)]) {
        return [self.dataSource addImageInPhotoView:self];
    }else {
        return [UIImage imageNamed:@"activity_addPhoto"];
    }
}

#pragma mark -
#pragma mark - 删除按钮的图片
- (UIImage *)deleteImage
{
    if ([self.dataSource respondsToSelector:@selector(deleteImageInPhotoView:)]) {
        return [self.dataSource deleteImageInPhotoView:self];
    }else {
        return [UIImage imageNamed:@"lf_addPhoto_delete"];
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return lf_addPhoto_count <= self.maxCount ? lf_addPhoto_count : self.maxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lf_addPhoto_Identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.image = self.photos[indexPath.row];
    cell.deleteHidden = indexPath.row == lf_addPhoto_count - 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == lf_addPhoto_count - 1) {
        if ([self.delegate respondsToSelector:@selector(photoViewAddPhoto:)]) {
            [self.delegate photoViewAddPhoto:self];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(photoView:didSelectAtIndex:)]) {
            [self.delegate photoView:self didSelectAtIndex:indexPath.row];
        }
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

#pragma mark -
#pragma mark - LFAddPhotoCellDelegate
- (void)photoCellDidDelete:(LFAddPhotoCell *)cell
{
    [self.photos removeObject:cell.image];
    [self.images removeObject:cell.image];
    [self.collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(photoView:didDeleteImage:)]) {
        [self.delegate photoView:self didDeleteImage:cell.image];
    }
}

- (UIImage *)deleteImageInPhotoCell:(LFAddPhotoCell *)cell
{
    return self.deleteImage;
}

@end
