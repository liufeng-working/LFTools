//
//  LFTools.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/2/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "LFTools.h"
#import "SDImageCache.h"
#import "LFFit.h"

@implementation LFTools

/**
 同步获取网络图片尺寸
 
 @param urlStr 图片url字符串
 @return 图片尺寸
 */
+ (CGSize)imageSize:(NSString *)urlStr
{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *cacheImg = [cache imageFromCacheForKey:urlStr];
    if (cacheImg) {
        return [LFFit fitSize:cacheImg.size];
    }
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    UIImage *image = [UIImage imageWithData:imgData];
    if (image) {
        [cache storeImage:image forKey:urlStr completion:nil];
        return [LFFit fitSize:image.size];
    }
    
    return CGSizeMake(200, 200);
}

/**
 手机的mac地址
 */
+ (NSString *)macAddress
{//方法来源于另一个项目，具体出处不明
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    
    mgmtInfoBase[0] = CTL_NET;
    mgmtInfoBase[1] = AF_ROUTE;
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;
    mgmtInfoBase[4] = NET_RT_IFLIST;
    mgmtInfoBase[5] = if_nametoindex("en0");
    
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
        return NULL;
    }else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0){
        return NULL;
    }else if ((msgBuffer = malloc(length)) == NULL) {
        return NULL;
    }else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
        return NULL;
    }
    
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
    free(msgBuffer);
    return macAddressString;
}

/**
 获取请求头（格式{header: {}, body: {}}）
 
 @param method 方法名称
 @param body 请求头的body参数
 */
+ (NSDictionary *)headerParamWithMethod:(NSString *)method
                                   body:(NSDictionary *)body
{
    //header部分
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionary];
    [headerDic setValue:@"" forKey:@"retCode"];
    [headerDic setValue:@"" forKey:@"retMsg"];
    
    NSString* deviceType = [UIDevice currentDevice].model;
    [headerDic setValue:deviceType ? deviceType : @"" forKey:@"deviceType"];
    
    NSString* sysName = [UIDevice currentDevice].systemName;
    NSString* sysVersion = [UIDevice currentDevice].systemVersion;
    
    if (sysName.length > 0 &&
        sysVersion.length > 0) {
        [headerDic setValue:[NSString stringWithFormat:@"%@%@",sysName,sysVersion] forKey:@"deviceOS"];
    }else if ([sysName length] > 0) {
        [headerDic setValue:sysName forKey:@"deviceOS"];
    }else if (sysVersion.length > 0){
        [headerDic setValue:sysName forKey:@"deviceOS"];
    }else {
        [headerDic setValue:@"" forKey:@"deviceOS"];
    }
    
    NSString * macAddress = self.macAddress;
    [headerDic setValue:macAddress ? macAddress : @"" forKey:@"deviceMac"];
    
    [headerDic setValue:method forKey:@"methodName"];
    [headerDic setValue:@"" forKey:@"version"];
    [headerDic setValue:@"" forKey:@"remark"];
    
    NSString *langStr = [@"中文" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [headerDic setValue:langStr forKey:@"remark1"];
    [headerDic setValue:@"" forKey:@"remark2"];
    
    return @{
             @"header": headerDic,
             @"body"  : body
             };
}

/**
 相机授权状态
 
 @return 状态码
 AVAuthorizationStatusNotDetermined,等待授权
	AVAuthorizationStatusRestricted,访问受限
	AVAuthorizationStatusDenied,拒绝
	AVAuthorizationStatusAuthorized,已授权
 */
+ (AVAuthorizationStatus)cameraAuthorization//相机授权
{
    return [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

/**
 相册授权
 
 @return 状态码
 PHAuthorizationStatusNotDetermined = 0,
 PHAuthorizationStatusRestricted,
 PHAuthorizationStatusDenied,
 PHAuthorizationStatusAuthorized,
 */
+ (PHAuthorizationStatus)photoAuthorization//照片授权
{
    return  [PHPhotoLibrary authorizationStatus];
}

/**
 跳转到手机设置页面
 
 @param failure 失败回调
 */
+ (void)jumpToiPhoneSetting:(void(^)(void))failure
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingUrl]) {
        if ([app respondsToSelector:@selector(openURL:)]) {                            [app openURL:settingUrl];
        }else {
            if (@available(iOS 10.0, *)) {
                [app openURL:settingUrl options:@{} completionHandler:^(BOOL success) {
                    if (!success && failure) {
                        failure();
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }else {
        if (failure) {
            failure();
        }
    }
}

// 保存图片到自定义相册
- (void)savePhotoToCustomAlbum:(UIImage *)image
                     albumName:(NSString *)name
                    completion:(void(^)(BOOL success))com
{
    if (image == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    PHAssetCollection *assetC = [self createAlbum:name];
    if (assetC == nil) {
        //相机相册
        assetC = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    }
    
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholderForCreatedAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeholderForCreatedAsset = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
    } error:&error];
    
    if (error || placeholderForCreatedAsset == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *collectionR = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetC];
        [collectionR insertAssets:@[placeholderForCreatedAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (com) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    com(NO);
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                com(YES);
            });
        }
    }];
}

/**
 保存图片到相机相册
 */
- (void)savePhotoToRollAlbum:(UIImage *)image
                  completion:(void(^ _Nullable)(BOOL success))com
{
    if (image == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } error:&error];
    
    if (error) {
        if (com) {
            com(NO);
        }
    }else {
        if (com) {
            com(YES);
        }
    }
}

//保存视频到相册
- (void)saveVideoToCustomAlbum:(NSURL *)videoUrl
                     albumName:(nullable NSString *)name
                    completion:(void(^ _Nullable)(BOOL success))com
{
    if (videoUrl == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    PHAssetCollection *assetC = [self createAlbum:name];
    if (assetC == nil) {
        //相机相册
        assetC = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    }
    
    NSError *error = nil;
    __block PHObjectPlaceholder *placeholderForCreatedAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        placeholderForCreatedAsset = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl].placeholderForCreatedAsset;
    } error:&error];
    
    if (error || placeholderForCreatedAsset == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollectionChangeRequest *collectionR = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetC];
        [collectionR insertAssets:@[placeholderForCreatedAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (com) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    com(NO);
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                com(YES);
            });
        }
    }];
}

/**
 保存视频到相机相册
 
 @param videoUrl fileUrl
 */
- (void)saveVideoToRollAlbum:(NSURL *)videoUrl
                  completion:(void(^ _Nullable)(BOOL success))com
{
    if (videoUrl == nil) {
        if (com) {
            com(NO);
        }
        return;
    }
    
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
    } error:&error];
    
    if (error) {
        if (com) {
            com(NO);
        }
    }else {
        if (com) {
            com(YES);
        }
    }
}

// 创建自定义相册
- (PHAssetCollection *)createAlbum:(NSString *)name
{
    if (!name || [name isEqualToString:@""] || [name stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        name = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    }
    
    PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetC in albums) {
        if ([assetC.localizedTitle isEqualToString:name]) {
            return assetC;
        }
    }
    
    NSError *error = nil;
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        localIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) {
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject;
}

@end
