//
//  LFThumbnailViewController.h
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

/************************************************************/
/** 某个相册所有缩略图的控制器 */
/************************************************************/
#import <UIKit/UIKit.h>

@class LFAlbumModel;
@protocol LFThumbnailViewControllerDelegate;
@interface LFThumbnailViewController : UICollectionViewController

@property(nonatomic,strong) LFAlbumModel *albumM;

@property(nonatomic,weak) id<LFThumbnailViewControllerDelegate> delegate;

@end

@protocol LFThumbnailViewControllerDelegate <NSObject>

@optional

/**
 取消
 */
- (void)thumbnailViewControllerDidCancel:(LFThumbnailViewController *)thumbnailVC;

/**
 完成选择
 */
- (void)thumbnailViewControllerDidFinishPicking:(LFThumbnailViewController *)thumbnailVC;
@end
