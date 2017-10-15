//
//  LFCollectionViewWaterfallLayout.h
//  LFStudy
//
//  Created by 刘丰 on 2017/8/3.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFCollectionViewDelegateWaterfallLayout;
@interface LFCollectionViewWaterfallLayout : UICollectionViewLayout

@property(nonatomic,weak) id<LFCollectionViewDelegateWaterfallLayout> delegate;

@end

@protocol LFCollectionViewDelegateWaterfallLayout <NSObject>

@required

/**
 每个位置cell的size
 */
- (CGSize)waterfallLayout:(LFCollectionViewWaterfallLayout *)waterfallLayout sizeForItemAtIndex:(NSUInteger)index;

@optional

/**
 几列（默认3列）
 */
- (NSUInteger)columnInLayout:(LFCollectionViewWaterfallLayout *)waterfallLayout;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)insetInLayout:(LFCollectionViewWaterfallLayout *)waterfallLayout;

/**
 列间距（默认10）
 */
- (CGFloat)columnSpacingInLayout:(LFCollectionViewWaterfallLayout *)collectionViewLayout;

/**
 行间距（默认10）
 */
- (CGFloat)rowSpacingInLayout:(LFCollectionViewWaterfallLayout *)waterfallLayout;

@end
