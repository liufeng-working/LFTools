//
//  LFThumbnailItem.m
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFThumbnailItem.h"
#import "LFImageView.h"
#import "LFImageManager.h"

@interface LFThumbnailItem ()<LFImageViewDelegate>

@property(nonatomic,weak) LFImageView *imageView;

@end

@implementation LFThumbnailItem

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LFImageView *imgView = [[LFImageView alloc] initWithFrame:self.contentView.bounds];
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

- (LFImageViewType)imageType:(LFAssetModel *)asset
{
    switch (asset.type) {
        case LFAssetMediaTypeUnknown:
            return LFImageViewTypeNone;
        case LFAssetMediaTypePhoto:
            return LFImageViewTypePhoto;
        case LFAssetMediaTypeVideo:
            return LFImageViewTypeVideo1 | LFImageViewTypePhoto;
        case LFAssetMediaTypeGif:
            return LFImageViewTypeGif | LFImageViewTypePhoto;
        case LFAssetMediaTypeAudio:
            return LFImageViewTypeAudio;
    }
}

#pragma mark -
#pragma mark - LFImageViewDelegate
- (void)imageView:(LFImageView *)imageView didPickerClick:(BOOL)isSelect
{
    self.assetM.select = isSelect;//设置模型的选中状态
    if ([self.delegate respondsToSelector:@selector(thumbnailItem:didPickerClick:thumbnail:)]) {
        [self.delegate thumbnailItem:self didPickerClick:isSelect thumbnail:self.imageView.image];
    }
    
    if (isSelect) {
        //提前获取大图
        [[LFImageManager manager] big:self.assetM completion:nil];
        //提前获取原图数据
//        [[LFImageManager manager] imageData:self.assetM completion:nil];
    }
}

@end
