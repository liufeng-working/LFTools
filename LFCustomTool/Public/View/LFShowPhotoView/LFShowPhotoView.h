//
//  LFShowPhotoView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/9/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LFShowPhotoViewDelegate;
@protocol LFShowPhotoViewDataSource;
@interface LFShowPhotoView : UIView

/**
 代理
 */
@property(nonatomic,weak) IBOutlet id<LFShowPhotoViewDelegate> delegate;
@property(nonatomic,weak) IBOutlet id<LFShowPhotoViewDataSource> dataSource;

/**
 图片数组（选择其中一个赋值）
 */
@property(nonatomic,strong) NSArray<UIImage *> *images;
@property(nonatomic,strong) NSArray<NSURL *> *urls;

/**
 图片数组（可以装自己定义的模型，然后实现下面的block，返回模型中可用的字段<UIImage/NSURL>）
 */
@property(nonatomic,strong) NSArray <id> *items;
@property(nonatomic,copy) id (^item_map)(id item);

/**
 合适的大小（能全部展示），有改变就会回调
 */
@property(nonatomic,copy) void(^lfAddPhotoViewFitSize)(CGSize size);

/**
 合适的大小（能全部展示）
 */
@property(nonatomic,assign,readonly) CGSize fitSize;

/**
 图片浏览器是否可用（默认YES）
 */
@property(nonatomic,assign) BOOL photoBrowserEnable;

@end

@protocol LFShowPhotoViewDelegate <NSObject>

@optional

/**
 选中某一个
 */
- (void)photoView:(LFShowPhotoView *)photoView didSelectAtIndex:(NSUInteger)index;

@end

@protocol LFShowPhotoViewDataSource <NSObject>

@required

@optional
/**
 最大个数（默认3个）
 */
- (NSUInteger)showPhotoViewMaxCount:(LFShowPhotoView *)photoView;

/**
 列数（默认3个）
 */
- (NSUInteger)showPhotoViewColumnCount:(LFShowPhotoView *)photoView;

/**
 cell的size
 */
- (CGSize)showPhotoViewItemSize:(LFShowPhotoView *)photoView;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)showPhotoViewInsets:(LFShowPhotoView *)photoView;

/**
 列间距（默认10）
 */
- (CGFloat)showPhotoViewColumnSpacing:(LFShowPhotoView *)photoView;

/**
 行间距（默认10）
 */
- (CGFloat)showPhotoViewRowSpacing:(LFShowPhotoView *)photoView;

/**
 滚动方向
 */
- (UICollectionViewScrollDirection)showPhotoViewScrollDirection:(LFShowPhotoView *)photoView;

@end

NS_ASSUME_NONNULL_END
