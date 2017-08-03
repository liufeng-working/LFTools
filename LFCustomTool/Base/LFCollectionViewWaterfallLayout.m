//
//  LFCollectionViewWaterfallLayout.m
//  LFStudy
//
//  Created by 刘丰 on 2017/8/3.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFCollectionViewWaterfallLayout.h"

@interface LFCollectionViewWaterfallLayout ()

@property(nonatomic,strong) NSMutableArray<UICollectionViewLayoutAttributes *> *atts;

@property(nonatomic,strong) NSMutableArray<NSNumber *> *heights;

@end

@implementation LFCollectionViewWaterfallLayout

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)atts
{
    if (!_atts) {
        _atts = [NSMutableArray array];
    }
    return _atts;
}

- (NSMutableArray<NSNumber *> *)heights
{
    if (!_heights) {
        _heights = [NSMutableArray array];
    }
    return _heights;
}

- (NSUInteger)column
{
    if ([self.delegate respondsToSelector:@selector(columnInLayout:)]) {
        return [self.delegate columnInLayout:self];
    }else {
        return 3;
    }
}

- (UIEdgeInsets)inset
{
    if ([self.delegate respondsToSelector:@selector(insetInLayout:)]) {
        return [self.delegate insetInLayout:self];
    }else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (CGFloat)columnSpacing
{
    if ([self.delegate respondsToSelector:@selector(columnSpacingInLayout:)]) {
        return [self.delegate columnSpacingInLayout:self];
    }else {
        return 10;
    }
}

- (CGFloat)rowSpacing
{
    if ([self.delegate respondsToSelector:@selector(rowSpacingInLayout:)]) {
        return [self.delegate rowSpacingInLayout:self];
    }else {
        return 10;
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.atts removeAllObjects];
    [self.heights removeAllObjects];
    
    for (NSInteger i = 0; i < self.column; i ++) {
        [self.heights addObject:@(self.inset.top - self.rowSpacing)];
    }
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < items; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.atts addObject:att];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.atts;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat min = self.heights.firstObject.floatValue;
    NSInteger minIndex = 0;
    for (NSInteger i = 1; i < self.heights.count; i ++) {
        CGFloat current = self.heights[i].floatValue;
        if (current < min) {
            min = current;
            minIndex = i;
        }
    }
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemW = (width - self.inset.left - self.inset.right - (self.column - 1)*self.columnSpacing)/self.column;
    CGFloat x = self.inset.left + minIndex*(itemW + self.columnSpacing);
    CGFloat y = min + self.rowSpacing;
    CGFloat w = itemW;
    CGSize originS = [self.delegate waterfallLayout:self sizeForItemAtIndex:indexPath.row];
    CGFloat h = originS.height*w/originS.width;
    att.frame = CGRectMake(x, y, w, h);
    self.heights[minIndex] = @(CGRectGetMaxY(att.frame));
    return att;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (CGSize)collectionViewContentSize {
    
    CGFloat max = self.heights.firstObject.floatValue;
    for (NSInteger i = 1; i < self.heights.count; i ++) {
        CGFloat current = self.heights[i].floatValue;
        if (current > max) {
            max = current;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, max + self.inset.bottom);
}

@end
