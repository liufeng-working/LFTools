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
+ (void)gotoiPhoneSettingFailure:(void(^)())failure;

@end
