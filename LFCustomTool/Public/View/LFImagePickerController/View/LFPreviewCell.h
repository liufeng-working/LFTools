//
//  LFPreviewCell.h
//  test
//
//  Created by 刘丰 on 2017/2/7.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 预览大图cell */
/************************************************************/

#import <UIKit/UIKit.h>

@class LFAssetModel;
@protocol LFPreviewCellDelegate;
@interface LFPreviewCell : UICollectionViewCell

@property(nonatomic,strong) LFAssetModel *assetModel;
@property(nonatomic,weak) id<LFPreviewCellDelegate> delegate;

- (void)playEnd;

@end

@protocol LFPreviewCellDelegate <NSObject>

@optional

/**
 点击了item
 */
- (void)previewCellDidClick:(LFPreviewCell *)cell;

/**
 点击了播放按钮
 */
- (void)previewCellDidClickPlayerButton:(LFPreviewCell *)cell;

@end
