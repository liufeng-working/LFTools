//
//  LFAddPhotoView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFAddPhotoViewDelegate;
@protocol LFAddPhotoViewDataSource;
@interface LFAddPhotoView : UIView

/**
 代理
 */
@property(nonatomic,weak) IBOutlet id<LFAddPhotoViewDelegate> delegate;
@property(nonatomic,weak) IBOutlet id<LFAddPhotoViewDataSource> dataSource;

/**
 图片
 */
@property(nonatomic,strong,readonly) NSMutableArray<UIImage *> *images;

/**
 图片数量改变
 说明：
 1.实现这个block，delegate就会失效
 2.里面封装了
 ```
 [UIViewController showImagePickerWithCompletion:^(UIImage *originalImage, UIImage *editedImage) {
 }];
 ```
 和
 ```
 LFPhotoBrowserViewController *pbVC = [[LFPhotoBrowserViewController alloc] init];
 pbVC.images = photoView.images;
 pbVC.currentIndex = index;
 [pbVC show];
 ```
 3.也可以自己去实现对应的代理方法，完成个性化展示UIImagePickerController和图片浏览
 */
@property(nonatomic,copy) void(^lfPhotoCountDidChange)(LFAddPhotoView *photoView, NSUInteger photoCount);

/**
 合适的大小（能全部展示），有改变就会回调
 */
@property(nonatomic,copy) void(^lfAddPhotoViewFitSize)(CGSize size);

/**
 合适的大小（能全部展示）
 */
@property(nonatomic,assign,readonly) CGSize fitSize;

/**
 添加一张图
 */
- (void)addImage:(UIImage *)image;

/**
 添加多张图
 */
- (void)addImages:(NSArray<UIImage *> *)images;

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
- (UIImage *)addImage;

/**
 删除按钮的图片
 */
- (UIImage *)deleteImage;

/**
 滚动方向
 */
- (UICollectionViewScrollDirection)scrollDirection;

@end

@protocol LFAddPhotoViewDelegate <NSObject>

@optional

/**
 添加图片
 */
- (void)addPhotoViewAdd:(LFAddPhotoView *)photoView;

/**
 删除某一个
 */
- (void)addPhotoView:(LFAddPhotoView *)photoView didDeleteImage:(UIImage *)image;

/**
 选中某一个
 */
- (void)addPhotoView:(LFAddPhotoView *)photoView didSelectAtIndex:(NSUInteger)index;

@end

@protocol LFAddPhotoViewDataSource <NSObject>

@optional
/**
 最大个数（默认3个）
 */
- (NSUInteger)addPhotoViewMaxCount:(LFAddPhotoView *)photoView;

/**
 列数（默认3个）
 */
- (NSUInteger)addPhotoViewColumnCount:(LFAddPhotoView *)photoView;

/**
 cell的size
 */
- (CGSize)addPhotoViewItemSize:(LFAddPhotoView *)photoView;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)addPhotoViewInsets:(LFAddPhotoView *)photoView;

/**
 列间距（默认10）
 */
- (CGFloat)addPhotoViewColumnSpacing:(LFAddPhotoView *)photoView;

/**
 行间距（默认10）
 */
- (CGFloat)addPhotoViewRowSpacing:(LFAddPhotoView *)photoView;

/**
 添加按钮的图片
 */
- (UIImage *)addPhotoViewImageOfAdd:(LFAddPhotoView *)photoView;

/**
 删除按钮的图片
 */
- (UIImage *)addPhotoViewImageOfDelete:(LFAddPhotoView *)photoView;

/**
 滚动方向
 */
- (UICollectionViewScrollDirection)addPhotoViewScrollDirection:(LFAddPhotoView *)photoView;

@end

NS_ASSUME_NONNULL_END
