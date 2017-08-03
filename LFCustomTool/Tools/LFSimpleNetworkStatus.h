//
//  LFSimpleNetworkStatus.h
//  LFCustomTool-Demo
//
//  Created by NJWC on 16/11/8.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetworkStatusType) {
    
    NetworkStatusTypeNoService = 0, //无服务
    NetworkStatusType2G =        1, //2G
    NetworkStatusType3G =        2, //3G
    NetworkStatusType4G =        3, //4G
    NetworkStatusTypeLTE =       4, //
    NetworkStatusTypeWiFi =      5, //WIFI
};

@interface LFSimpleNetworkStatus : NSObject

/**
 *  利用私有API快速检测当前网络类型
 */
+ (NetworkStatusType)currentStatus;

/**
 *  网络是否可用
 */
+ (BOOL)isAvailable;

/**
 *  是否是WiFi
 */
+ (BOOL)isWiFi;

/**
 *  是否是蜂窝网（数据流量）
 */
+ (BOOL)isWWAN;

@end
