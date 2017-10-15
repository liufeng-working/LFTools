//
//  LFShowPhotoView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/9/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LFShowPhotoViewDelegate;
@protocol LFShowPhotoViewDataSource;
@interface LFShowPhotoView : UIView

/**
 代理
 */
@property(nonatomic,weak) id<LFShowPhotoViewDelegate> delegate;
@property(nonatomic,weak) id<LFShowPhotoViewDataSource> dataSource;

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
- (NSUInteger)maxCount:(LFShowPhotoView *)photoView;

/**
 列数（默认3个）
 */
- (NSUInteger)columnCount:(LFShowPhotoView *)photoView;

/**
 每个位置cell的size
 */
- (CGSize)photoView:(LFShowPhotoView *)photoView sizeAtIndex:(NSUInteger)index;

/**
 上下左右间距（默认{0, 0, 0, 0}）
 */
- (UIEdgeInsets)insetInPhotoView:(LFShowPhotoView *)photoView;

/**
 列间距（默认10）
 */
- (CGFloat)columnSpacingInPhotoView:(LFShowPhotoView *)photoView;

/**
 行间距（默认10）
 */
- (CGFloat)rowSpacingInPhotoView:(LFShowPhotoView *)photoView;

/**
 添加按钮的图片
 */
- (UIImage *)addImageInPhotoView:(LFShowPhotoView *)photoView;

/**
 删除按钮的图片
 */
- (UIImage *)deleteImageInPhotoView:(LFShowPhotoView *)photoView;

@end
