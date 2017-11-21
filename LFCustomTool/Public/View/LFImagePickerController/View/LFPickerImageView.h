//
//  LFPickerImageView.h
//  
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

//表示这个LFImageView的样式（可以多选组合使用）
typedef NS_OPTIONS(NSInteger, LFPickerImageViewType) {
    LFPickerImageViewTypeNone   = 0     ,//原始样式
    LFPickerImageViewTypePhoto  = 1 << 0,//图片选择按钮
    LFPickerImageViewTypeVideo  = 1 << 2,//播放按钮
    LFPickerImageViewTypeVideo1 = 1 << 3,//摄像头+时间
    LFPickerImageViewTypeGif    = 1 << 4,//动图 字样
    LFPickerImageViewTypeGif1   = 1 << 5,//GIF 字样
};

@protocol LFPickerImageViewDelegate;
@interface LFPickerImageView : UIImageView

@property(nonatomic,assign) LFPickerImageViewType type;

/** 当type为LFImageViewTypeVideo1类型，这个值才有意义 */
@property(nonatomic,copy) NSString *videoTime;

@property(nonatomic,weak) id<LFPickerImageViewDelegate> delegate;

/**
 自己是否被选中
 */
- (void)setupSelect:(BOOL)select;

@end

@protocol LFPickerImageViewDelegate <NSObject>

@optional
/**
 点击选择图片
 */
- (void)pickerImageView:(LFPickerImageView *)imageView didPickerClick:(BOOL)isSelect;

@end

@protocol LFPhotoPickerButtonDelegate;
@interface LFPhotoPickerButton : UIButton

@property(nonatomic,weak) id<LFPhotoPickerButtonDelegate> delegate;

@end

@protocol LFPhotoPickerButtonDelegate <NSObject>

@optional
- (void)photoPickerButtonClick:(LFPhotoPickerButton *)sender;

@end
