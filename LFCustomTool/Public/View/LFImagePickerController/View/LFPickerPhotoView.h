//
//  LFPickerPhotoView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFPickerPhotoViewDelegate;
@protocol LFPickerPhotoViewDataSource;
@class LFPublicModel;
@interface LFPickerPhotoView : UIView

/**
 代理
 */
@property(nonatomic,weak) IBOutlet id<LFPickerPhotoViewDelegate> delegate;
@property(nonatomic,weak) IBOutlet id<LFPickerPhotoViewDataSource> dataSource;

/**
 图片模型
 */
@property(nonatomic,strong) NSArray<LFPublicModel *> *publicMs;

/**
 合适的大小（能全部展示），有改变就会回调
 */
@property(nonatomic,copy) void(^lfPickerPhotoViewFitSize)(CGSize size);

/**
 合适的大小（能全部展示）
 */
@property(nonatomic,assign,readonly) CGSize fitSize;

/**
 清除内容
 */
- (void)clear;

/**
 最大图片数
 */
- (NSUInteger)maxCount;

/**
 列数
 */
- (NSUInteger)columnCount;

/**
 item的size
 */
- (CGSize)itemSize;

/**
 上左下右缩紧
 */
- (UIEdgeInsets)insets;

/**
 列间距
 */
- (CGFloat)columnSpacing;

/**
 行间距
 */
- (NSUInteger)rowSpacing;

/**
 添加按钮的图片
 */
- (UIImage *)imageOfAdd;

/**
 删除按钮的图片
 */
- (UIImage *)imageOfDelete;

/**
 滚动方向
 */
- (UICollectionViewScrollDirection)scrollDirection;

@end

@protocol LFPickerPhotoViewDelegate <NSObject>

@optional

/**
 添加图片
 */
- (void)pickerPhotoViewAdd:(LFPickerPhotoView *)photoView;

/**
 删除某一个
 */
- (void)pickerPhotoView:(LFPickerPhotoView *)photoView didDeleteAtIndex:(NSUInteger)index;

/**
 选中某一个
 */
- (void)pickerPhotoView:(LFPickerPhotoView *)photoView didSelectAtIndex:(NSUInteger)index;

@end

@protocol LFPickerPhotoViewDataSource <NSObject>

@optional
/**
 最大个数（默认3个）
 */
- (NSUInteger)pickerPhotoViewMaxCount:(LFPickerPhotoView *)photoView;

/**
 列数（默认3个）
 */
- (NSUInteger)pickerPhotoViewColumnCount:(LFPickerPhotoView *)photoView;

/**
 cell的size
 */
- (CGSize)pickerPhotoViewItemSize:(LFPickerPhotoView *)photoView;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)pickerPhotoViewInsets:(LFPickerPhotoView *)photoView;

/**
 列间距（默认10）
 */
- (CGFloat)pickerPhotoViewColumnSpacing:(LFPickerPhotoView *)photoView;

/**
 行间距（默认10）
 */
- (CGFloat)pickerPhotoViewRowSpacing:(LFPickerPhotoView *)photoView;

/**
 添加按钮的图片
 */
- (UIImage *)pickerPhotoViewImageOfAdd:(LFPickerPhotoView *)photoView;

/**
 删除按钮的图片
 */
- (UIImage *)pickerPhotoViewImageOfDelete:(LFPickerPhotoView *)photoView;

/**
 滚动方向
 */
- (UICollectionViewScrollDirection)pickerPhotoViewScrollDirection:(LFPickerPhotoView *)photoView;

@end

NS_ASSUME_NONNULL_END
