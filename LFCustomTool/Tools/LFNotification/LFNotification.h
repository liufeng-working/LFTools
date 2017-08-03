//
//  LFNotification.h
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

//对MBProgressHUD进行二次封装
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface LFNotification : NSObject

//自动隐藏
+ (void)autoHideWithIndicator;
+ (void)autoHideWithText:(NSString*)text;
+ (void)autoHideIndicatorWithText:(NSString*)text;
+ (void)autoHideIndicatorWithText:(NSString*)text addTo:(UIView *)view;

//手动隐藏
+ (void)manuallyHideWithIndicator;
+ (void)manuallyHideWithText:(NSString*)text;
+ (void)manuallyHideIndicatorWithText:(NSString*)text;
+ (void)manuallyHideIndicatorWithText:(NSString*)text addTo:(UIView *)view;

//隐藏
+ (void)hideNotification;

+ (void)setHUDUserInteractionEnabled:(BOOL)enabled;

//背景
+ (void)setDimBackground:(BOOL)enabled;

@end
