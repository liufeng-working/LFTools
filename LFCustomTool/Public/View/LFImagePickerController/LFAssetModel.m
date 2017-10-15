//
//  LFAssetModel.m
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFAssetModel.h"
#import "LFImagePickerTool.h"

@implementation LFAssetModel

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        
        _asset = asset;
        _type = [self assetType:asset];
        _videoTime = [LFImagePickerTool timeFromTimeInterval:asset.duration];
        _duration = asset.duration;
        _select = NO;
        _localIdentifier = asset.localIdentifier;
        _ID = [asset.localIdentifier stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        _fileName = [asset valueForKey:@"filename"];
        _suffix = self.fileName.pathExtension;
    }
    return self;
}

+ (instancetype)assetModel:(PHAsset *)asset
{
    return [[self alloc] initWithAsset:asset];
}


- (instancetype)init
{
    NSAssert(NO, @"请使用\"+ assetModel:\"或\"- initWithAsset:\"构建对象");
    return nil;
}

+ (instancetype)new
{
    NSAssert(NO, @"请使用\"+ assetModel:\"或\"- initWithAsset:\"构建对象");
    return nil;
}

#pragma mark -
#pragma mark - 判断资源类型
- (LFAssetMediaType)assetType:(PHAsset *)asset
{
    LFAssetMediaType type = LFAssetMediaTypeUnknown;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        type = LFAssetMediaTypePhoto;
        if ([[[asset valueForKey:@"filename"] uppercaseString] hasSuffix:@"GIF"]) {
            type = LFAssetMediaTypeGif;
        }
    }else if (asset.mediaType == PHAssetMediaTypeVideo) {
        type = LFAssetMediaTypeVideo;
    }else if (asset.mediaType == PHAssetMediaTypeAudio) {
        type = LFAssetMediaTypeAudio;
    }
    
    return type;
}

@end
