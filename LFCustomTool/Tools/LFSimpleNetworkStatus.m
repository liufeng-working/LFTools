//
//  LFSimpleNetworkStatus.m
//  LFCustomTool-Demo
//
//  Created by NJWC on 16/11/8.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFSimpleNetworkStatus.h"

@implementation LFSimpleNetworkStatus

/**
 *  利用私有API快速检测当前网络类型
 */
+ (NetworkStatusType)currentStatus
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    NSString *str = [NSString stringWithFormat:@"%@StatusBar%@Network%@View", @"UI",@"Data",@"Item"];
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(str) class]]) {
            
            dataNetworkItemView = subview;
            break;
        }
    }
    
    return dataNetworkItemView ? [[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue] : NetworkStatusTypeNoService;
}

/**
 *  网络是否可用
 */
+ (BOOL)isAvailable
{
    return [self currentStatus] != NetworkStatusTypeNoService;
}

/**
 *  是否是WiFi
 */
+ (BOOL)isWiFi
{
    return [self currentStatus] == NetworkStatusTypeWiFi;
}

/**
 *  是否是蜂窝网（数据流量）
 */
+ (BOOL)isWWAN
{
    NetworkStatusType type = [self currentStatus];
    if (type == NetworkStatusType2G ||
        type == NetworkStatusType3G ||
        type == NetworkStatusType4G) {
        return YES;
    }
    
    return NO;
}

@end
