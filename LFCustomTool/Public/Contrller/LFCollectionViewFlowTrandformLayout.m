//
//  LFCollectionViewFlowTrandformLayout.m
//  LFStudy
//
//  Created by 刘丰 on 2017/8/3.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFCollectionViewFlowTrandformLayout.h"

@implementation LFCollectionViewFlowTrandformLayout

- (void)prepareLayout {
    [super prepareLayout];

}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray<__kindof UICollectionViewLayoutAttributes *> *atts = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat width = self.collectionView.frame.size.width;
    [atts enumerateObjectsUsingBlock:^(__kindof UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat scale = 1 - fabs(obj.center.x - self.collectionView.contentOffset.x - width*0.5)/(width*0.5)*0.25;
        obj.transform = CGAffineTransformMakeScale(scale, scale);
    }];
    return atts;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, width, height);
    NSArray<__kindof UICollectionViewLayoutAttributes *> *atts = [super layoutAttributesForElementsInRect:rect];
    
    __block CGFloat min = MAXFLOAT;
    [atts enumerateObjectsUsingBlock:^(__kindof UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat offsetX = obj.center.x - proposedContentOffset.x - width*0.5;
        if (fabs(offsetX) < fabs(min)) {
            min = offsetX;
        }
    }];

    return CGPointMake(proposedContentOffset.x + min, proposedContentOffset.y);
}

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

@end
