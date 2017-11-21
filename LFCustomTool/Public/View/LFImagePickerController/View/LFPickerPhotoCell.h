//
//  LFPickerPhotoCell.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFPickerPhotoCellDelegate;
@class LFPublicModel;
@interface LFPickerPhotoCell : UICollectionViewCell

@property(nonatomic,weak) id<LFPickerPhotoCellDelegate> delegate;

@property(nonatomic,strong) LFPublicModel *publicM;

@property(nonatomic,assign) BOOL deleteHidden;

@end

@protocol LFPickerPhotoCellDelegate <NSObject>

@required
/**
 删除按钮的图片
 */
- (UIImage *)pickerPhotoCellImageOfDelete:(LFPickerPhotoCell *)cell;

@optional
/**
 点击删除
 */
- (void)pickerPhotoCellDidDelete:(LFPickerPhotoCell *)cell;

@end

NS_ASSUME_NONNULL_END
