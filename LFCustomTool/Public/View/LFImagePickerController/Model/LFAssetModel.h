//
//  LFAssetModel.h
//  test
//
//  Created by 刘丰 on 2017/1/23.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 资源模型  */
/************************************************************/

#import <Photos/Photos.h>

//表示资源的类型
typedef NS_ENUM(NSInteger, LFAssetMediaType) {
    LFAssetMediaTypeUnknown = 0,
    LFAssetMediaTypePhoto,
    LFAssetMediaTypeGif,
    LFAssetMediaTypeVideo,
    LFAssetMediaTypeAudio,
};

// 资源模型
@interface LFAssetModel : NSObject

@property(nonatomic,strong,readonly) PHAsset *asset;

@property(nonatomic,assign,readonly) LFAssetMediaType type;

/**
 唯一标识符
 */
@property(nonatomic,copy,readonly) NSString *localIdentifier;

/**
 也是唯一标识符（把localIdentifier中的 "／" 替换为 "_"）
 */
@property(nonatomic,copy,readonly) NSString *ID;

/**
 名称
 */
@property(nonatomic,copy,readonly) NSString *fileName;

/**
 名称后缀
 */
@property(nonatomic,copy,readonly) NSString *suffix;

/**
 自己是否被选中
 */
@property(nonatomic,assign,getter=isSelect) BOOL select;

/** 如果是视频，这个属性才会有值 */
@property(nonatomic,copy,readonly) NSString *videoTime;
@property(nonatomic,assign,readonly) NSTimeInterval duration;

- (instancetype)initWithAsset:(PHAsset *)asset;
+ (instancetype)assetModel:(PHAsset *)asset;

@end
