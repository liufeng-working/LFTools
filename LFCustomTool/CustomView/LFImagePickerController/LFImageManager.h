//
//  LFImageManager.h
//  test
//
//  Created by 刘丰 on 2017/1/19.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 获取资源 */
/************************************************************/

#import <UIKit/UIKit.h>
#import "LFAlbumModel.h"
#import "LFPublicModel.h"

//保存图片／视频成功后的回调
typedef void(^LFImageManagerSaveSuccess)(LFAssetModel *assetM, LFPublicModel *publicM);
//保存图片／视频失败后的回调
typedef void(^LFImageManagerSaveFailure)();

@interface LFImageManager : NSObject
/**
 单例
 */
+ (instancetype)manager;

/**
 获取主要几个相册（相机胶卷，视频，最近添加...,相册中图片不为空才会返回）
 
 @param showVideo 是否显示视频
 @param completion 完成回调
 */
- (void)allAlbums:(BOOL)showVideo
       completion:(void (^)(NSArray<LFAlbumModel *> *albumModels))completion;

/**
 获取视频相册
 
 @param completion 完成回调
 */
- (void)videoAlbumCompletion:(void (^)(LFAlbumModel *albumModel))completion;

/**
 获取相机相册
 
 @param completion 完成回调
 */
- (void)rollAlbums:(BOOL)showVideo
        completion:(void (^)(LFAlbumModel *albumM))completion;

/**
 获取缩略图

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)thumbnail:(LFAssetModel *)assetM
       completion:(void (^)(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model))completion;//isThumbnail判断是不是清晰点的图

/**
 获取大图（以屏幕宽度为最大宽度，供显示使用，上传用<+ originalData:complete:>）

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)big:(LFAssetModel *)assetM
 completion:(void (^)(UIImage *big, BOOL isBig))completion;//isBig：判断返回的是否为大图（会返回多个图片，先返回质量差的供占位使用，后返回大图）

/**
 获取原图
 
 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)original:(LFAssetModel *)assetM
      completion:(void (^)(UIImage *original))completion;

/**
 图片二进制数据
 */
- (void)imageData:(LFAssetModel *)assetM
       completion:(void (^)(NSData *imageData))completion;

/**
 获取视频

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)video:(LFAssetModel *)assetM
   completion:(void (^)(AVPlayerItem *playerItem))completion;

/**
 视频二进制数据
 */
- (void)videoData:(LFAssetModel *)assetM
       completion:(void (^)(NSData *videoData, CGSize size, NSError *error))completion;

/**
 保存图片到相册
 */
- (void)savePhotoToPhotosAlbum:(UIImage *)image
                       success:(LFImageManagerSaveSuccess)success
                       failure:(LFImageManagerSaveFailure)failure;

/**
 保存视频到相册
 */
- (void)saveVideoToPhotosAlbum:(NSURL *)videoPath
                       success:(LFImageManagerSaveSuccess)success
                       failure:(LFImageManagerSaveFailure)failure;

/**
 清空所有图片缓存
 */
- (void)clearMemory;
- (void)clearDiskOnCompletion:(void(^)())completion;

/**
 磁盘缓存
 */
- (NSUInteger)getSize;

@end
