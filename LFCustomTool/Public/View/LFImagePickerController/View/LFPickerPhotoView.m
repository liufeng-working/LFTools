//
//  LFPickerPhotoView.m
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPickerPhotoView.h"
#import "LFPickerPhotoCell.h"
#import "LFImagePickerTool.h"
#import "LFPublicModel.h"

#define lf_pickerPhoto_count self.privatePublicMs.count
#define lf_pickerPhoto_contentSizeKey @"contentSize"

static NSString *lf_pickerPhoto_Identifier = @"LFPickerPhotoCell";
@interface LFPickerPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LFPickerPhotoCellDelegate>

@property(nonatomic,weak) UICollectionView *collectionView;

@property(nonatomic,strong) NSMutableArray<LFPublicModel *> *privatePublicMs;
@property(nonatomic,strong) LFPublicModel *addPublicM;

@end

@implementation LFPickerPhotoView
@synthesize publicMs = _publicMs;

- (NSMutableArray<LFPublicModel *> *)privatePublicMs
{
    if (!_privatePublicMs) {
        _privatePublicMs = [NSMutableArray array];
    }
    return _privatePublicMs;
}

- (LFPublicModel *)addPublicM
{
    if (!_addPublicM) {
        _addPublicM = [LFPublicModel publicModelWithImage:self.imageOfAdd type:LFAssetMediaTypePhoto];
    }
    return _addPublicM;
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
    [collection registerClass:[LFPickerPhotoCell class] forCellWithReuseIdentifier:lf_pickerPhoto_Identifier];
    
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
    [self.privatePublicMs addObject:self.addPublicM];
    [self.collectionView addObserver:self forKeyPath:lf_pickerPhoto_contentSizeKey options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)setDataSource:(id<LFPickerPhotoViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if (self.collectionView) {
        ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = self.scrollDirection;
    }
}

- (void)setPublicMs:(NSArray<LFPublicModel *> *)publicMs
{
    _publicMs = publicMs;
    
    [self.privatePublicMs removeAllObjects];
    [self.privatePublicMs addObjectsFromArray:publicMs];
    [self.privatePublicMs addObject:self.addPublicM];
    [self.collectionView reloadData];
}

- (NSArray<LFPublicModel *> *)publicMs
{
    NSMutableArray *tempArr = self.privatePublicMs.mutableCopy;
    [tempArr removeLastObject];
    return tempArr;
}

#pragma mark -
#pragma mark - 清除内容
- (void)clear
{
    [self.privatePublicMs removeAllObjects];
    [self.privatePublicMs addObject:self.addPublicM];
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - 最大个数
- (NSUInteger)maxCount
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewMaxCount:)]) {
        return [self.dataSource pickerPhotoViewMaxCount:self];
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - 列数
- (NSUInteger)columnCount
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewColumnCount:)]) {
        return [self.dataSource pickerPhotoViewColumnCount:self] ?: 1;
    }else {
        return 3;
    }
}

#pragma mark -
#pragma mark - cell的size
- (CGSize)itemSize
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewItemSize:)]) {
        CGSize size = [self.dataSource pickerPhotoViewItemSize:self];
        return [LFImagePickerTool fitSize:size maxSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
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
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewInsets:)]) {
        return [self.dataSource pickerPhotoViewInsets:self];
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

#pragma mark -
#pragma mark - 列间距
- (CGFloat)columnSpacing
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewColumnSpacing:)]) {
        return [self.dataSource pickerPhotoViewColumnSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 行间距
- (NSUInteger)rowSpacing
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewRowSpacing:)]) {
        return [self.dataSource pickerPhotoViewRowSpacing:self];
    }else {
        return 10.f;
    }
}

#pragma mark -
#pragma mark - 添加按钮的图片
- (UIImage *)imageOfAdd
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewImageOfAdd:)]) {
        UIImage *img = [self.dataSource pickerPhotoViewImageOfAdd:self];
        NSAssert(img, @"添加按钮的图片不能为nil");
        return img;
    }else {
        return [LFImagePickerTool imageNamed:@"add"];
    }
}

#pragma mark -
#pragma mark - 删除按钮的图片
- (UIImage *)imageOfDelete
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewImageOfDelete:)]) {
        UIImage *img = [self.dataSource pickerPhotoViewImageOfDelete:self];
        NSAssert(img, @"删除按钮的图片不能为nil");
        return img;
    }else {
        return [LFImagePickerTool imageNamed:@"delete"];
    }
}

#pragma mark -
#pragma mark - 滚动方向
- (UICollectionViewScrollDirection)scrollDirection
{
    if ([self.dataSource respondsToSelector:@selector(pickerPhotoViewScrollDirection:)]) {
        return [self.dataSource pickerPhotoViewScrollDirection:self];
    }else {
        return UICollectionViewScrollDirectionVertical;
    }
}

#pragma mark -
#pragma mark - 监测内容尺寸改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:lf_pickerPhoto_contentSizeKey]) {
        CGSize oldS = [change[NSKeyValueChangeOldKey] CGSizeValue];
        CGSize newS = [change[NSKeyValueChangeNewKey] CGSizeValue];
        if (!CGSizeEqualToSize(oldS, newS)) {
            _fitSize = CGSizeMake(newS.width + self.insets.left + self.insets.right, newS.height + self.insets.top + self.insets.bottom);
            if (self.lfPickerPhotoViewFitSize) {
                self.lfPickerPhotoViewFitSize(self.fitSize);
            }
        }
    }
}

#pragma mark -
#pragma mark - LFPickerPhotoCellDelegate
- (void)pickerPhotoCellDidDelete:(LFPickerPhotoCell *)cell
{
    NSUInteger index = [self.privatePublicMs indexOfObject:cell.publicM];
    [self.privatePublicMs removeObjectAtIndex:index];
    [self.collectionView reloadData];
    
    [self scroll];
    
    if ([self.delegate respondsToSelector:@selector(pickerPhotoView:didDeleteAtIndex:)]) {
        [self.delegate pickerPhotoView:self didDeleteAtIndex:index];
    }
}

- (UIImage *)pickerPhotoCellImageOfDelete:(LFPickerPhotoCell *)cell
{
    return self.imageOfDelete;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return lf_pickerPhoto_count <= self.maxCount ? lf_pickerPhoto_count : self.maxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    LFPickerPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lf_pickerPhoto_Identifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.publicM = self.privatePublicMs[indexPath.row];
    cell.deleteHidden = indexPath.row == lf_pickerPhoto_count - 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == lf_pickerPhoto_count - 1) {
        if ([self.delegate respondsToSelector:@selector(pickerPhotoViewAdd:)]) {
            [self.delegate pickerPhotoViewAdd:self];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(pickerPhotoView:didSelectAtIndex:)]) {
            [self.delegate pickerPhotoView:self didSelectAtIndex:indexPath.row];
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
    if (self.lfPickerPhotoViewFitSize) {
        return;
    }
    
    if (lf_pickerPhoto_count >= 1 && lf_pickerPhoto_count <= self.maxCount) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:lf_pickerPhoto_count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:lf_pickerPhoto_contentSizeKey];
}

@end
