//
//  LFAddPhotoView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFAddPhotoViewDelegate;
@protocol LFAddPhotoViewDataSource;
@interface LFAddPhotoView : UIView

/**
 代理
 */
@property(nonatomic,weak) id<LFAddPhotoViewDelegate> delegate;
@property(nonatomic,weak) id<LFAddPhotoViewDataSource> dataSource;

/**
 图片
 */
@property(nonatomic,strong,readonly) NSMutableArray<UIImage *> *images;

/**
 添加一张图
 */
- (void)addImage:(UIImage *)image;

/**
 添加多张图
 */
- (void)addImages:(NSArray<UIImage *> *)images;

@end

@protocol LFAddPhotoViewDelegate <NSObject>

@optional

/**
 添加图片
 */
- (void)photoViewAddPhoto:(LFAddPhotoView *)photoView;

/**
 删除某一个
 */
- (void)photoView:(LFAddPhotoView *)photoView didDeleteImage:(UIImage *)image;

/**
 选中某一个
 */
- (void)photoView:(LFAddPhotoView *)photoView didSelectAtIndex:(NSUInteger)index;

@end

@protocol LFAddPhotoViewDataSource <NSObject>

@required

@optional
/**
 最大个数（默认3个）
 */
- (NSUInteger)maxCount:(LFAddPhotoView *)photoView;

/**
 列数（默认3个）
 */
- (NSUInteger)columnCount:(LFAddPhotoView *)photoView;

/**
 每个位置cell的size
 */
- (CGSize)photoView:(LFAddPhotoView *)photoView sizeAtIndex:(NSUInteger)index;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)insetInPhotoView:(LFAddPhotoView *)photoView;

/**
 列间距（默认10）
 */
- (CGFloat)columnSpacingInPhotoView:(LFAddPhotoView *)photoView;

/**
 行间距（默认10）
 */
- (CGFloat)rowSpacingInPhotoView:(LFAddPhotoView *)photoView;

/**
 添加按钮的图片
 */
- (UIImage *)addImageInPhotoView:(LFAddPhotoView *)photoView;

/**
 删除按钮的图片
 */
- (UIImage *)deleteImageInPhotoView:(LFAddPhotoView *)photoView;

@end
