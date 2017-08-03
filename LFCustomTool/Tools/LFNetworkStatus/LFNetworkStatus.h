//
//  LFNetworkStatus.h
//  test
//
//  Created by NJWC on 16/8/9.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LFNetwork [LFNetworkStatus shareNetworkStatus]
#define LFNetworkIsAvailable LFNetwork.isAvailable

/**
 网络变化的通知，首先要打开autoCheckNetworkChange = YES
 变化后的网络状态在 通知的object属性中
 */
FOUNDATION_EXPORT NSString *const LFReachabilityChangedNotification;

#define Unknown @"Unknown"
#define NoService @"NoService"
#define WiFi @"WiFi"
#define WWAN @"WWAN"

#define WWAN_Unknown @"WWAN_Unknown"
#define WWAN_2G @"WWAN_2G"
#define WWAN_3G @"WWAN_3G"
#define WWAN_4G @"WWAN_4G"

typedef NS_ENUM(NSInteger, NetworkType) {
    
    NetworkTypeUnknown   = -1, //未知网络
    NetworkTypeNoService =  0, //无服务
    NetworkTypeWiFi =       1, //WIFI
    NetworkTypeWWAN =       2, //蜂窝网
};

typedef NS_ENUM(NSInteger, NetworkWWANType) {
    
    NetworkWWANTypeUnknown = 0, //未知
    NetworkWWANType2G =      1, //2G
    NetworkWWANType3G =      2, //3G
    NetworkWWANType4G =      3, //4G
    
};

@interface LFNetworkStatus : NSObject

/**
 *  是否检测网络变化
 */
@property (nonatomic, assign)BOOL autoCheckNetworkChange;

/**
 *  获取实例对象（单例）
 */
+ (LFNetworkStatus *)shareNetworkStatus;

/**
 *  检测当前网络类型
 */
- (NetworkType)currentNetworkType;
- (NSString *)currentNetworkTypeDefine;

/**
 *  检测蜂窝网类型
 */
- (NetworkWWANType)currentWWANType;
- (NSString *)currentWWANTypeDefine;

/**
 *  网络是否可用
 */
- (BOOL)isAvailable;

/**
 *  是否是WiFi
 */
- (BOOL)isWiFi;

/**
 *  是否是蜂窝网（数据流量）
 */
- (BOOL)isWWAN;

@end
