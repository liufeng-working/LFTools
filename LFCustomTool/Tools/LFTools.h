//
//  LFTools.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/2/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface LFTools : NSObject

/**
 同步获取网络图片尺寸
 
 @param urlStr 图片url字符串
 @return 图片尺寸
 */
+ (CGSize)imageSize:(NSString *)urlStr;

/**
 手机的mac地址
 */
+ (NSString *)macAddress;

/**
 获取请求头（格式{header: {}, body: {}}）
 
 @param method 方法名称
 @param body 请求头的body参数
 */
+ (NSDictionary *)headerParamWithMethod:(NSString *)method
                                   body:(NSDictionary *)body;

/**
 相机授权状态

 @return 状态码
 AVAuthorizationStatusNotDetermined,等待授权
	AVAuthorizationStatusRestricted,访问受限
	AVAuthorizationStatusDenied,拒绝
	AVAuthorizationStatusAuthorized,已授权
 */
+ (AVAuthorizationStatus)cameraAuthorization;

/**
 相册授权

 @return 状态码
 PHAuthorizationStatusNotDetermined = 0,
 PHAuthorizationStatusRestricted,
 PHAuthorizationStatusDenied,
 PHAuthorizationStatusAuthorized,
 */
+ (PHAuthorizationStatus)photoAuthorization;

/**
 跳转到手机设置页面
 
 @param failure 失败回调
 */
+ (void)jumpToiPhoneSetting:(void(^)(void))failure;

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

@end
