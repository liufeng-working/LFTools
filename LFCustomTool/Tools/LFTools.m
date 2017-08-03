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
+ (void)gotoiPhoneSettingFailure:(void(^)())failure
{
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {//可以打开设置
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(openURL:)]) {// >=ios10版本
            [app openURL:settingUrl];
        }else {// <iOS10版本
            [app openURL:settingUrl options:@{} completionHandler:nil];
        }
    }else {//不可以打开设置
        if (failure) {
            failure();
        }
    }
}

@end
