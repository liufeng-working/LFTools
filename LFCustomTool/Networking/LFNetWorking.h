//
//  LFNetWorking.h
//  KTUAV
//
//  Created by 刘丰 on 2017/5/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#pragma mark -
#pragma mark - 基础的url
/** 基础的url */
#define isFormal 1
#if !isFormal
/***********************测试环境 0***********************/
//普通业务
#define kBaseUrl @"http://192.168.1.121:8080/uav/mobile/commonRequestAction"
//图片地址前缀
#define kBaseUrlPhotoBrowseHeader @"http://61.160.96.90:6263/"
//上传图片接口
#define kBaseUrlUpload @"http://192.168.1.121:8080/uav/mobile/UploadRequestAction"
#else
/***********************正式环境 1***********************/
//普通业务
#define kBaseUrl @"http://61.160.96.90:6263/uav/mobile/commonRequestAction"
//图片地址前缀
#define kBaseUrlPhotoBrowseHeader @"http://61.160.96.90:6263/"
//上传图片接口
#define kBaseUrlUpload @"http://61.160.96.90:6263/uav/mobile/UploadRequestAction"
#endif

#import <Foundation/Foundation.h>

@interface LFNetWorking : NSObject

/**
 *  POST请求获取数据
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POSTWithParameters:(NSDictionary *)parameters
                   success:(void (^)(id result))success
                   failure:(void (^)(NSError *error))failure;

/**
 *  POST请求上传图片
 *
 *  @param parameters 参数列表
 *  @param images     上传的图片
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)uploadWithParameters:(NSDictionary *)parameters
                      images:(NSArray<UIImage *> *)images
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure;

@end
