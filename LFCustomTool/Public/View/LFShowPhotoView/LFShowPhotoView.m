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

#define lf_showPhoto_contentSizeKey @"contentSize"

static NSString *lf_showPhoto_Identifier = @"LFShowPhotoCell";
@interface LFShowPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak) UICollectionView *collectionView;

@end

@implementation LFShowPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self defaultSetting];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
    [self defaultSetting];
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
    [collection registerClass:[LFShowPhotoCell class] forCellWithReuseIdentifier:lf_showPhoto_Identifier];
    
    // 添加约束
    collection.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collection);
    NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collection]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:hC];
    
    NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collection]-0-|" options:0 metrics:nil views:views];
    [self addConstraints:vC];
}

- (void)defaultSetting
{
    _photoBrowserEnable = YES;
    
    [self.collectionView addObserver:self forKeyPath:lf_showPhoto_contentSizeKey options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -
#pragma mark - 最大个数
- (NSUInteger)maxCount
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewMaxCount:)]) {
        return [self.dataSource showPhotoViewMaxCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 列数
- (NSUInteger)columnCount
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewColumnCount:)]) {
        return [self.dataSource showPhotoViewColumnCount:self] ?: 1;
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 每个位置cell的size
- (CGSize)itemSize
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewItemSize:)]) {
        CGSize size = [self.dataSource showPhotoViewItemSize:self];
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
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewInsets:)]) {
        return [self.dataSource showPhotoViewInsets:self];
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark -
#pragma mark - 列间距
- (CGFloat)columnSpacing
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewColumnSpacing:)]) {
        return [self.dataSource showPhotoViewColumnSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 行间距
- (NSUInteger)rowSpacing
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewRowSpacing:)]) {
        return [self.dataSource showPhotoViewRowSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 滚动方向
- (UICollectionViewScrollDirection)scrollDirection
{
    if ([self.dataSource respondsToSelector:@selector(showPhotoViewScrollDirection:)]) {
        return [self.dataSource showPhotoViewScrollDirection:self];
    }else {
        return UICollectionViewScrollDirectionVertical;
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
#pragma mark - 监测内容尺寸改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:lf_showPhoto_contentSizeKey]) {
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
    if (self.photoBrowserEnable) {
        LFPhotoBrowserViewController *pbVC = [[LFPhotoBrowserViewController alloc] init];
        pbVC.currentIndex = indexPath.row;
        if (self.images.count != 0) {
            pbVC.images = self.images;
        }else if (self.urls.count != 0) {
            pbVC.urls = self.urls;
        }else if (self.items.count != 0) {
            pbVC.items = self.items;
            pbVC.item_map = self.item_map;
        }
        [pbVC show];
    }
    if ([self.delegate respondsToSelector:@selector(photoView:didSelectAtIndex:)]) {
        [self.delegate photoView:self didSelectAtIndex:indexPath.row];
    }else {
        
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

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:lf_showPhoto_contentSizeKey];
}

@end
