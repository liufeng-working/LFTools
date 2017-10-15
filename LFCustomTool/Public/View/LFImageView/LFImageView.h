//
//  LFImageView.h
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//表示这个LFImageView的样式（可以多选组合使用）
typedef NS_OPTIONS(NSInteger, LFImageViewType) {
    LFImageViewTypeNone   = 0     ,//原始样式
    LFImageViewTypePhoto  = 1 << 0,//图片选择按钮
    LFImageViewTypePhoto1 = 1 << 1,//图片删除按钮
    LFImageViewTypeVideo  = 1 << 2,//播放按钮
    LFImageViewTypeVideo1 = 1 << 3,//摄像头+时间
    LFImageViewTypeGif    = 1 << 4,//动图 字样
    LFImageViewTypeGif1   = 1 << 5,//GIF 字样
    LFImageViewTypeAudio  = 1 << 6,//暂无
    //more...
};

@protocol LFImageViewDelegate;
@interface LFImageView : UIImageView

@property(nonatomic,assign) LFImageViewType type;

/** 当type为LFImageViewTypeVideo1类型，这个值才有意义 */
@property(nonatomic,copy) NSString *videoTime;

@property(nonatomic,weak) id<LFImageViewDelegate> delegate;

/**
 自己是否被选中
 */
- (void)setupSelect:(BOOL)select;

@end

@protocol LFImageViewDelegate <NSObject>

@optional
/**
 点击选择图片
 */
- (void)imageView:(LFImageView *)imageView didPickerClick:(BOOL)isSelect;

/**
 点击删除按钮
 */
- (void)imageViewDidClickDelete:(LFImageView *)imageView;

@end

@protocol LFPhotoPickerButtonDelegate;
@interface LFPhotoPickerButton : UIButton

@property(nonatomic,weak) id<LFPhotoPickerButtonDelegate> delegate;

@end

@protocol LFPhotoPickerButtonDelegate <NSObject>

@optional
- (void)photoPickerButtonClick:(LFPhotoPickerButton *)sender;

@end
