//
//  LFPhotoFlowLayout.m
//  自定义流水布局
//
//  Created by 刘丰 on 2017/6/4.
//  Copyright © 2017年 liufeng. All rights reserved.

/**
 自定义布局，需要了解以下几个方法
 
 - (void)prepareLayout;
 
 - (CGSize)collectionViewContentSize;
 
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
 
 - (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
 
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
 
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
 */

#import "LFPhotoFlowLayout.h"

@implementation LFPhotoFlowLayout

/**
 作用：计算cell的布局
 条件：cell的位置固定不变
 调用：collectionview第一次布局或刷新
 */
- (void)prepareLayout {
    [super prepareLayout];
}


/**
 计算collectionview的滚动范围
 */
- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

/**
 返回指定区域内cell的尺寸

 @param rect 区域
 @return UICollectionViewLayoutAttributes：确定cell的尺寸，一个对象对应一个cell
 */
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //collectionView的可见范围
    CGRect visibleR = self.collectionView.bounds;
    NSArray<__kindof UICollectionViewLayoutAttributes *> *cells = [super layoutAttributesForElementsInRect:visibleR];
    CGFloat offsetx = self.collectionView.contentOffset.x;
    CGFloat widthHalf = CGRectGetWidth(self.collectionView.bounds)*0.5;
    [cells enumerateObjectsUsingBlock:^(__kindof UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat delta = fabs(obj.center.x - offsetx - widthHalf);
        CGFloat scale = 1 - (delta/widthHalf)*0.25;
        obj.transform = CGAffineTransformMakeScale(scale, scale);
    }];
    return cells;
}

/**
 滚动时是否允许刷新（invalidate：刷新）

 @param newBounds 区域
 @return YES/NO
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/**
 确定最终的偏移量(手指松开时调用)

 @param proposedContentOffset 最终偏移量
 @param velocity 速度
 @return 偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //手指松开时的偏移量
//    CGPoint offset = self.collectionView.contentOffset;
    
    //最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    NSArray<__kindof UICollectionViewLayoutAttributes *> *cells = [self layoutAttributesForElementsInRect:CGRectMake(targetP.x, 0, width, MAXFLOAT)];
    __block CGFloat minDelta = MAXFLOAT;
    [cells enumerateObjectsUsingBlock:^(__kindof UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat delta = obj.center.x - targetP.x - width*0.5;
        if (fabs(delta) < fabs(minDelta)) {
            minDelta = delta;
        }
    }];
    return CGPointMake(targetP.x + minDelta, targetP.y);
}

@end
