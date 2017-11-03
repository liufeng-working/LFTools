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
#define lf_addPhoto_contentSizeKey @"contentSize"

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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupSubviews];
        [self setupDefault];
    }
    return self;
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = self.scrollDirection;
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
    
    [self.collectionView addObserver:self forKeyPath:lf_addPhoto_contentSizeKey options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
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
    
    [self scroll];
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
    
    [self scroll];
}

#pragma mark -
#pragma mark - 最大个数
- (NSUInteger)maxCount
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewMaxCount:)]) {
        return [self.dataSource addPhotoViewMaxCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 列数
- (NSUInteger)columnCount
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewColumnCount:)]) {
        return [self.dataSource addPhotoViewColumnCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 每个位置cell的size
- (CGSize)itemSize
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewItemSize:)]) {
        return [self.dataSource addPhotoViewItemSize:self];
    }else {
        CGFloat itemW = (CGRectGetWidth(self.frame) - self.insets.left - self.insets.right - (self.columnCount - 1)*self.columnSpacing - 1)/self.columnCount;
        return CGSizeMake(itemW, itemW);
    }
}

#pragma mark -
#pragma mark - 上下左右间距
- (UIEdgeInsets)insets
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewInsets:)]) {
        return [self.dataSource addPhotoViewInsets:self];
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark -
#pragma mark - 列间距
- (CGFloat)columnSpacing
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewColumnSpacing:)]) {
        return [self.dataSource addPhotoViewColumnSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 行间距
- (NSUInteger)rowSpacing
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewRowSpacing:)]) {
        return [self.dataSource addPhotoViewRowSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 添加按钮的图片
- (UIImage *)addImage
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewImageOfAdd:)]) {
        return [self.dataSource addPhotoViewImageOfAdd:self];
    }else {
        return [UIImage imageNamed:@"lf_addPhoto_add"];
    }
}

#pragma mark -
#pragma mark - 删除按钮的图片
- (UIImage *)deleteImage
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewImageOfDelete:)]) {
        return [self.dataSource addPhotoViewImageOfDelete:self];
    }else {
        return [UIImage imageNamed:@"lf_addPhoto_delete"];
    }
}

#pragma mark -
#pragma mark - 滚动方向
- (UICollectionViewScrollDirection)scrollDirection
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewScrollDirection:)]) {
        return [self.dataSource addPhotoViewScrollDirection:self];
    }else {
        return UICollectionViewScrollDirectionVertical;
    }
}

#pragma mark -
#pragma mark - 监测内容尺寸改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:lf_addPhoto_contentSizeKey]) {
        CGSize oldS = [change[NSKeyValueChangeOldKey] CGSizeValue];
        CGSize newS = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if (!CGSizeEqualToSize(oldS, newS)) {
            _fitSize = CGSizeMake(newS.width + self.insets.left + self.insets.right, newS.height + self.insets.top + self.insets.bottom);
            if (self.lfAddPhotoViewFitSize) {
                self.lfAddPhotoViewFitSize(self.fitSize);
            }
        }
    }
}

#pragma mark -
#pragma mark - LFAddPhotoCellDelegate
- (void)addPhotoCellDidDelete:(LFAddPhotoCell *)cell
{
    [self.photos removeObject:cell.image];
    [self.images removeObject:cell.image];
    [self.collectionView reloadData];
    
    [self scroll];
    
    if (self.lfPhotoCountDidChange) {
        self.lfPhotoCountDidChange(self, self.images.count);
    }else {
        if ([self.delegate respondsToSelector:@selector(addPhotoView:didDeleteImage:)]) {
            [self.delegate addPhotoView:self didDeleteImage:cell.image];
        }
    }
}

- (UIImage *)addPhotoCellImageOfDelete:(LFAddPhotoCell *)cell
{
    return self.deleteImage;
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
        if (self.lfPhotoCountDidChange) {
            [kWindow.rootViewController showImagePickerWithCompletion:^(UIImage *originalImage, UIImage *editedImage) {
                [self addImage:originalImage];
                self.lfPhotoCountDidChange(self, self.images.count);
            }];
        }else {
            if ([self.delegate respondsToSelector:@selector(addPhotoViewAdd:)]) {
                [self.delegate addPhotoViewAdd:self];
            }
        }
    }else {
        if (self.lfPhotoCountDidChange) {
            LFPhotoBrowserViewController *pbVC = [[LFPhotoBrowserViewController alloc] init];
            pbVC.images = self.images;
            pbVC.currentIndex = indexPath.row;
            [pbVC show];
        }else {
            if ([self.delegate respondsToSelector:@selector(addPhotoView:didSelectAtIndex:)]) {
                [self.delegate addPhotoView:self didSelectAtIndex:indexPath.row];
            }
        }
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.rowSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.columnSpacing;
}

#pragma mark -
#pragma mark - private
- (void)scroll
{
    if (self.lfAddPhotoViewFitSize) {
        return;
    }
    
    if (lf_addPhoto_count >= self.columnCount && lf_addPhoto_count <= self.maxCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photos.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:lf_addPhoto_contentSizeKey];
}

@end
