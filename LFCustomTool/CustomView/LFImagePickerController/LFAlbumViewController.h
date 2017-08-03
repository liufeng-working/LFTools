//
//  LFAlbumViewController.h
//  test
//
//  Created by 刘丰 on 2017/1/20.
//  Copyright © 2017年 liufeng. All rights reserved.
//

/************************************************************/
/** 相册控制器 */
/************************************************************/
#import <UIKit/UIKit.h>

@class LFAlbumModel;
@protocol LFAlbumViewControllerDelegate;
@interface LFAlbumViewController : UITableViewController

@property(nonatomic,strong,readonly) NSArray<LFAlbumModel *> *albumArr;

@property(nonatomic,weak) id<LFAlbumViewControllerDelegate> delegate;

@end

@protocol LFAlbumViewControllerDelegate <NSObject>

@optional

/**
 取消
 */
- (void)albumViewControllerDidCancel:(LFAlbumViewController *)albumVC;

/**
 完成选择
 */
- (void)albumViewControllerDidFinishPicking:(LFAlbumViewController *)albumVC;

@end
