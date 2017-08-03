//
//  LFThumbnailItem.h
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 缩略图item */
/************************************************************/

#import <UIKit/UIKit.h>

@class LFAssetModel;
@protocol LFThumbnailItemDelegate;
@interface LFThumbnailItem : UICollectionViewCell

@property(nonatomic,strong) LFAssetModel *assetM;

@property(nonatomic,weak) id<LFThumbnailItemDelegate> delegate;

@end

@protocol LFThumbnailItemDelegate <NSObject>

@optional

/**
 点击选择按钮选
 
 @param isSelect 选中还是未选中
 @param thumbnail 缩略图
 */
- (void)thumbnailItem:(LFThumbnailItem *)item didPickerClick:(BOOL)isSelect thumbnail:(UIImage *)thumbnail;

@end
