//
//  LFNetworkStatus.m
//  test
//
//  Created by NJWC on 16/8/9.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "LFNetworkStatus.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NSString *const LFReachabilityChangedNotification = @"LFNetworkReachabilityChangedNotification";

@interface LFNetworkStatus ()

@property (nonatomic, strong)Reachability *reachability;

@property (nonatomic,strong) NSArray *typeStrings4G;
@property (nonatomic,strong) NSArray *typeStrings3G;
@property (nonatomic,strong) NSArray *typeStrings2G;

@end

static LFNetworkStatus *_networkStatus = nil;
@implementation LFNetworkStatus

/**
 *  获取单例
 */
+ (LFNetworkStatus *)shareNetworkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkStatus = [[self alloc] init];
    });
    return _networkStatus;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkStatus = [super allocWithZone:zone];
    });
    return _networkStatus;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            self.reachability = [Reachability reachabilityForInternetConnection];
            
            self.typeStrings2G = @[CTRadioAccessTechnologyEdge,
                                   CTRadioAccessTechnologyGPRS,
                                   CTRadioAccessTechnologyCDMA1x];
            
            self.typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                                   CTRadioAccessTechnologyWCDMA,
                                   CTRadioAccessTechnologyHSUPA,
                                   CTRadioAccessTechnologyCDMAEVDORev0,
                                   CTRadioAccessTechnologyCDMAEVDORevA,
                                   CTRadioAccessTechnologyCDMAEVDORevB,
                                   CTRadioAccessTechnologyeHRPD];
            
            self.typeStrings4G = @[CTRadioAccessTechnologyLTE];
        });
    }
    return self;
}

- (void)setAutoCheckNetworkChange:(BOOL)autoCheckNetworkChange
{
    _autoCheckNetworkChange = autoCheckNetworkChange;
    if (autoCheckNetworkChange == YES) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        [self.reachability startNotifier];
        
    } else {
        [self.reachability stopNotifier];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)reachabilityChanged:(NSNotification *)note
{
    //可以用通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LFReachabilityChangedNotification object:[self currentNetworkTypeDefine]];
}

/**
 *  检测当前网络类型
 */
- (NetworkType)currentNetworkType
{
    NetworkStatus netStatus = [self.reachability currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:     return NetworkTypeNoService;
        case ReachableViaWiFi: return NetworkTypeWiFi;
        case ReachableViaWWAN: return NetworkTypeWWAN;
        default:               return NetworkTypeUnknown;
    }
}

- (NSString *)currentNetworkTypeDefine
{
    NetworkStatus netStatus = [self.reachability currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:     return NoService;
        case ReachableViaWiFi: return WiFi;
        case ReachableViaWWAN: return WWAN;
        default:               return Unknown;
    }
}
/**
 *  检测蜂窝网类型
 */
- (NetworkWWANType)currentWWANType
{
    if ([self currentNetworkType] != NetworkTypeWWAN) return NetworkWWANTypeUnknown;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) return NetworkWWANTypeUnknown;
    
    CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
    NSString *accessString = teleInfo.currentRadioAccessTechnology;
    if (accessString.length <= 0) return NetworkWWANTypeUnknown;

    return [self accessTypeForString:accessString];
}

- (NSString *)currentWWANTypeDefine
{
    NetworkWWANType type = [self currentWWANType];
    switch (type) {
        case NetworkWWANType2G: return WWAN_2G;
        case NetworkWWANType3G: return WWAN_3G;
        case NetworkWWANType4G: return WWAN_4G;
        default:                return WWAN_Unknown;
    }
}

- (NetworkWWANType)accessTypeForString:(NSString *)accessString
{
    if ([self.typeStrings4G containsObject:accessString]) return NetworkWWANType4G;
    if ([self.typeStrings3G containsObject:accessString]) return NetworkWWANType3G;
    if ([self.typeStrings2G containsObject:accessString]) return NetworkWWANType2G;
    
    return NetworkWWANTypeUnknown; 
}

/**
 *  网络是否可用
 */
- (BOOL)isAvailable
{
    return [self currentNetworkType] != NetworkTypeNoService && [self currentNetworkType] != NetworkTypeUnknown;
}

/**
 *  是否是WiFi
 */
- (BOOL)isWiFi
{
    return [self currentNetworkType] == NetworkTypeWiFi;
}

/**
 *  是否是蜂窝网（数据流量）
 */
- (BOOL)isWWAN
{
    return [self currentNetworkType] == NetworkTypeWWAN;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
