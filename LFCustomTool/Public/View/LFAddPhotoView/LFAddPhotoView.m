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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
    [self setupDefault];
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
    
    // 添加约束
    collection.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collection);
    NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:hC];
    
    NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:vC];
}

- (void)setupDefault
{
    [self.photos addObject:self.addImage];
    
    [self.collectionView addObserver:self forKeyPath:lf_addPhoto_contentSizeKey options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)setDataSource:(id<LFAddPhotoViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if (self.photos.count) {
        [self.photos replaceObjectAtIndex:self.photos.count - 1 withObject:self.addImage];
    }
    
    if (self.collectionView) {
        ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = self.scrollDirection;
    }
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
#pragma mark - 清除内容
- (void)clear
{
    [self.photos removeAllObjects];
    [self.photos addObject:self.addImage];
    [self.collectionView reloadData];
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
        
        return [self.dataSource addPhotoViewColumnCount:self] ?: 1;
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - cell的size
- (CGSize)itemSize
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewItemSize:)]) {
        CGSize size = [self.dataSource addPhotoViewItemSize:self];
        return [self fitSize:size maxSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
    }else {
        CGFloat itemW = (CGRectGetWidth(self.frame) - self.insets.left - self.insets.right - (self.columnCount - 1)*self.columnSpacing - 1)/self.columnCount;
        if (itemW <= 10) {
            itemW = 10;
        }
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
        UIImage *img = [self.dataSource addPhotoViewImageOfAdd:self];
        NSAssert(img, @"添加按钮的图片不能为nil");
        return img;
    }else {
        return [self imageWithNamed:@"lf_addPhoto_add"];
    }
}

#pragma mark -
#pragma mark - 删除按钮的图片
- (UIImage *)deleteImage
{
    if ([self.dataSource respondsToSelector:@selector(addPhotoViewImageOfDelete:)]) {
        UIImage *img = [self.dataSource addPhotoViewImageOfDelete:self];
        NSAssert(img, @"删除按钮的图片不能为nil");
        return img;
    }else {
        return [self imageWithNamed:@"lf_addPhoto_delete"];
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
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.rowSpacing : self.columnSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.columnSpacing : self.rowSpacing;
}

#pragma mark -
#pragma mark - private
- (void)scroll
{
    if (self.lfAddPhotoViewFitSize) {
        return;
    }
    
    if (lf_addPhoto_count >= 1 && lf_addPhoto_count <= self.maxCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photos.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
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

- (UIImage *)imageWithNamed:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LFAddPhotoView.bundle" ofType:nil];
    NSBundle *imgBundle = [NSBundle bundleWithPath:path];
    return [UIImage imageNamed:name inBundle:imgBundle compatibleWithTraitCollection:nil];
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:lf_addPhoto_contentSizeKey];
}

@end
