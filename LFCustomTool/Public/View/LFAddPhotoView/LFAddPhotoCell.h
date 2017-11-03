//
//  LFAddPhotoCell.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFAddPhotoCellDelegate;
@interface LFAddPhotoCell : UICollectionViewCell

@property(nonatomic,weak) id<LFAddPhotoCellDelegate> delegate;

@property(nonatomic,strong) UIImage *image;

@property(nonatomic,assign) BOOL deleteHidden;

@end

@protocol LFAddPhotoCellDelegate <NSObject>

@required
/**
 删除按钮的图片
 */
- (UIImage *)addPhotoCellImageOfDelete:(LFAddPhotoCell *)cell;

@optional
/**
 点击删除
 */
- (void)addPhotoCellDidDelete:(LFAddPhotoCell *)cell;


@end

NS_ASSUME_NONNULL_END
