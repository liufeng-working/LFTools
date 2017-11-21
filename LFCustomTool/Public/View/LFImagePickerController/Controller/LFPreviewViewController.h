//
//  LFPreviewViewController.h
//  test
//
//  Created by 刘丰 on 2017/2/7.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 预览控制器 */
/************************************************************/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LFPreviewVCType) {
    LFPreviewVCTypePrevate = 0,//私有的
    LFPreviewVCTypePublic,//通过LFImagePickerController来初始化预览
};

@class LFAssetModel;
@protocol LFPreviewViewControllerDelegate;
@interface LFPreviewViewController : UICollectionViewController

@property(nonatomic,strong) NSArray<LFAssetModel *> *assets;

@property(nonatomic,assign) NSInteger currentIndex;

@property(nonatomic,weak) id<LFPreviewViewControllerDelegate> delegate;

@property(nonatomic,assign) LFPreviewVCType type;

@end

@protocol LFPreviewViewControllerDelegate <NSObject>

@optional

/**
 对图片进行选中和取消选中
 
 @param assetModel 修改图片对应的模型
 @param isSelect 选中还是取消选中
 */
- (void)previewViewController:(LFPreviewViewController *)previewVC didClickWithAssetModel:(LFAssetModel *)assetModel select:(BOOL)isSelect thumbnail:(UIImage *)thumbnail;

/**
 self.type = LFPreviewVCTypePublic时，单击效果是取消，会调用这个代理
 */
- (void)previewViewControllerDidCancel:(LFPreviewViewController *)previewVC;

@end
