//
//  LFPhotoBrowserCell.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFPhotoBrowserCellDelegate;
@class LFPhotoModel;
@interface LFPhotoBrowserCell : UICollectionViewCell

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) LFPhotoModel *photoModel;

@property(nonatomic,weak) id<LFPhotoBrowserCellDelegate> delegate;

@end

@protocol LFPhotoBrowserCellDelegate <NSObject>

@optional
- (void)didSelectPhotoBrowserCell:(LFPhotoBrowserCell *)cell;

@end
