//
//  LFPreviewItem.h
//  test
//
//  Created by 刘丰 on 2017/2/7.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 预览大图item */
/************************************************************/

#import <UIKit/UIKit.h>

@class LFAssetModel;
@protocol LFPreviewItemDelegate;
@interface LFPreviewItem : UICollectionViewCell

@property(nonatomic,strong) LFAssetModel *assetModel;
@property(nonatomic,weak) id<LFPreviewItemDelegate> delegate;

- (void)playEnd;

@end

@protocol LFPreviewItemDelegate <NSObject>

@optional

/**
 点击了item
 */
- (void)previewItemDidClick:(LFPreviewItem *)item;

/**
 点击了播放按钮
 */
- (void)previewItemDidClickPlayerButton:(LFPreviewItem *)item;

@end
