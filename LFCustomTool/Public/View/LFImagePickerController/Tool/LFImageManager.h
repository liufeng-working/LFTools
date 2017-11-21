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

NS_ASSUME_NONNULL_BEGIN

//保存图片／视频成功后的回调
typedef void(^LFImageManagerSaveSuccess)(LFAssetModel *assetM, LFPublicModel *publicM);
//保存图片／视频失败后的回调
typedef void(^LFImageManagerSaveFailure)(void);

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
       completion:(void (^ _Nullable)(NSArray<LFAlbumModel *> *albumModels))completion;

/**
 获取视频相册
 
 @param completion 完成回调
 */
- (void)videoAlbumCompletion:(void (^ _Nullable)(LFAlbumModel *albumModel))completion;

/**
 获取相机相册
 
 @param completion 完成回调
 */
- (void)rollAlbums:(BOOL)showVideo
        completion:(void (^ _Nullable)(LFAlbumModel *albumM))completion;

/**
 获取相机相册
 */
- (PHAssetCollection *)rollAlbum;

/**
 获取缩略图

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)thumbnail:(LFAssetModel *)assetM
       completion:(void (^ _Nullable)(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model))completion;//isThumbnail判断是不是清晰点的图

/**
 获取大图（以屏幕宽度为最大宽度，供显示使用，上传用<+ originalData:complete:>）

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)big:(LFAssetModel *)assetM
 completion:(void (^ _Nullable)(UIImage *big, BOOL isBig))completion;//isBig：判断返回的是否为大图（会返回多个图片，先返回质量差的供占位使用，后返回大图）

/**
 获取原图
 
 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)original:(LFAssetModel *)assetM
      completion:(void (^ _Nullable)(UIImage *original))completion;

/**
 图片二进制数据
 */
- (void)imageData:(LFAssetModel *)assetM
       completion:(void (^ _Nullable)(NSData *imageData))completion;

/**
 获取视频

 @param assetM 图片模型
 @param completion 完成回调
 */
- (void)video:(LFAssetModel *)assetM
   completion:(void (^ _Nullable)(AVPlayerItem *playerItem))completion;

/**
 视频二进制数据
 */
- (void)videoData:(LFAssetModel *)assetM
       completion:(void (^ _Nullable)(NSData *videoData, CGSize size, NSError *error))completion;

/**
 保存图片到相机相册（选择图片的时候使用）
 */
- (void)savePhotoToRollAlbum:(UIImage *)image
                       success:(nullable LFImageManagerSaveSuccess)success
                       failure:(nullable LFImageManagerSaveFailure)failure;

/**
 保存图片到自定义相册

 @param image 图片
 @param name 相册名称（没有这个相册，则会创建，传入nil、@""，则会用项目名称）
 @param com 完成后的回调
 */
- (void)savePhotoToCustomAlbum:(UIImage *)image
                     albumName:(nullable NSString *)name
                    completion:(void(^ _Nullable)(BOOL success))com;

/**
 保存图片到相机相册
 */
- (void)savePhotoToRollAlbum:(UIImage *)image
                    completion:(void(^ _Nullable)(BOOL success))com;

/**
 保存视频到相机相册（选择图片的时候使用）

 @param videoUrl fileUrl
 */
- (void)saveVideoToRollAlbum:(NSURL *)videoUrl
                       success:(nullable LFImageManagerSaveSuccess)success
                       failure:(nullable LFImageManagerSaveFailure)failure;

/**
 保存视频到自定义相册
 
 @param videoUrl fileUrl
 */
- (void)saveVideoToCustomAlbum:(NSURL *)videoUrl
                     albumName:(nullable NSString *)name
                    completion:(void(^ _Nullable)(BOOL success))com;

/**
 保存视频到相机相册
 
 @param videoUrl fileUrl
 */
- (void)saveVideoToRollAlbum:(NSURL *)videoUrl
                    completion:(void(^ _Nullable)(BOOL success))com;

/**
 创建自定义相册
 */
- (nullable PHAssetCollection *)createAlbum:(nullable NSString *)name;

/**
 自定义相册是否存在

 @param name 相册名
 */
- (nullable PHAssetCollection *)albumIsExit:(NSString *)name;

/**
 根据一组模型，获取一组图片二进制数据
 */
- (void)imageDatas:(NSArray<LFAssetModel *> *)assetMs
        completion:(void (^ _Nullable)(NSArray<NSData *> *imageDatas))completion;

/**
 清空所有图片缓存
 */
- (void)clearMemory;
- (void)clearDiskOnCompletion:(void(^ _Nullable)(void))completion;

/**
 磁盘缓存
 */
- (NSUInteger)getSize;

@end

NS_ASSUME_NONNULL_END
