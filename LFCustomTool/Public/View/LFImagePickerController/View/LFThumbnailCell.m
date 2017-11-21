//
//  LFThumbnailCell.m
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFThumbnailCell.h"
#import "LFPickerImageView.h"
#import "LFImageManager.h"

@interface LFThumbnailCell ()<LFPickerImageViewDelegate>

@property(nonatomic,weak) LFPickerImageView *imageView;

@end

@implementation LFThumbnailCell

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LFPickerImageView *imgView = [[LFPickerImageView alloc] initWithFrame:self.contentView.bounds];
        imgView.delegate = self;
        [self.contentView addSubview:imgView];
        _imageView = imgView;
    }
    return self;
}

#pragma mark -
#pragma mark - 重写set方法，设置属性
- (void)setAssetM:(LFAssetModel *)assetM
{
    _assetM = assetM;
    self.imageView.type = [self imageType:assetM];
    self.imageView.videoTime = assetM.videoTime;
    [self.imageView setupSelect:assetM.isSelect];//设置自己的选中状态
    [[LFImageManager manager] thumbnail:assetM completion:^(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model) {
        self.imageView.image = thumbnail;
    }];
}

- (LFPickerImageViewType)imageType:(LFAssetModel *)asset
{
    switch (asset.type) {
        case LFAssetMediaTypeUnknown:
            return LFPickerImageViewTypeNone;
        case LFAssetMediaTypePhoto:
            return LFPickerImageViewTypePhoto;
        case LFAssetMediaTypeVideo:
            return LFPickerImageViewTypeVideo1 | LFPickerImageViewTypePhoto;
        case LFAssetMediaTypeGif:
            return LFPickerImageViewTypeGif | LFPickerImageViewTypePhoto;
        case LFAssetMediaTypeAudio:
            return LFPickerImageViewTypeNone;
    }
}

#pragma mark -
#pragma mark - LFImageViewDelegate
- (void)pickerImageView:(LFPickerImageView *)imageView didPickerClick:(BOOL)isSelect
{
    self.assetM.select = isSelect;//设置模型的选中状态
    if ([self.delegate respondsToSelector:@selector(thumbnailCell:didPickerClick:thumbnail:)]) {
        [self.delegate thumbnailCell:self didPickerClick:isSelect thumbnail:self.imageView.image];
    }
    
    if (isSelect) {
        //提前获取大图
        [[LFImageManager manager] big:self.assetM completion:nil];
        //提前获取原图数据
//        [[LFImageManager manager] imageData:self.assetM completion:nil];
    }
}

@end
