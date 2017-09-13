//
//  LFNotification.m
//  SurfNewsHD
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "LFNotification.h"
#import "AppDelegate.h"

#define HideTime   1.0f
#define Margin     10.0f
#define YOffset    -20.0f
#define LabelFont  15
#define LFWINDOW [[[UIApplication sharedApplication] delegate] window]
#define Color [UIColor colorWithWhite:0 alpha:0.6]

@implementation LFNotification

MBProgressHUD *HUD = nil;

//自动隐藏
+ (void)autoHideWithIndicator
{
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
	
	HUD.removeFromSuperViewOnHide = YES;
    HUD.margin = Margin;
    HUD.yOffset = YOffset;
    HUD.userInteractionEnabled = YES;
	HUD.color = Color;
	[HUD hide:YES afterDelay:HideTime];
}

+ (void)autoHideWithText:(NSString*)text
{
    if (text == nil || text.length == 0) {
        
        return [LFNotification autoHideWithIndicator];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
	
	HUD.mode = MBProgressHUDModeText;
	HUD.labelText = text;
	HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
	HUD.userInteractionEnabled = YES;
	[HUD hide:YES afterDelay:HideTime];
}

+ (void)autoHideIndicatorWithText:(NSString*)text
{
    if (text == nil || text.length == 0) {
        return [LFNotification autoHideWithIndicator];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
    HUD.labelText = text;
    HUD.margin = Margin;
    HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    
    [HUD hide:YES afterDelay:HideTime];
}

+ (void)autoHideIndicatorWithText:(NSString*)text addTo:(UIView *)view
{
    if (text == nil || text.length == 0) {
        return [LFNotification autoHideWithIndicator];
    }
    
    if (view == nil) {
        return [LFNotification autoHideIndicatorWithText:text];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelText = text;
    HUD.margin = Margin;
    HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    
    [HUD hide:YES afterDelay:HideTime];
}

//手动隐藏
+ (void)manuallyHideWithIndicator
{
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
	
    HUD.margin = Margin;
	HUD.yOffset = YOffset;
	HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    HUD.dimBackground = YES;
    HUD.color = Color;
}

+ (void)manuallyHideWithText:(NSString*)text
{
    if (text == nil || text.length == 0) {
        return;
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
	
	HUD.mode = MBProgressHUDModeText;
	HUD.labelText = text;
	HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    HUD.dimBackground = YES;
}

+ (void)manuallyHideIndicatorWithText:(NSString*)text
{
    if (text == nil || text.length == 0) {
        return [LFNotification manuallyHideWithIndicator];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:LFWINDOW animated:YES];
	
	HUD.labelText = text;
    HUD.margin = Margin;
	HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
	HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    HUD.dimBackground = YES;
}

+ (void)manuallyHideIndicatorWithText:(NSString*)text addTo:(UIView *)view
{
    if (text == nil || text.length == 0) {
        return [LFNotification manuallyHideWithIndicator];
    }
    
    if (view == nil) {
        return [LFNotification manuallyHideIndicatorWithText:text];
    }
    
    if (HUD){
        [HUD hide:NO];
        HUD = nil;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    HUD.labelText = text;
    HUD.margin = Margin;
    HUD.yOffset = YOffset;
    HUD.color = Color;
    HUD.labelFont = [UIFont systemFontOfSize:LabelFont];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.userInteractionEnabled = YES;
    HUD.dimBackground = YES;
}

//隐藏
+ (void)hideNotification
{
    if (HUD) {
        [HUD hide:YES];
    }
}

+ (void)setHUDUserInteractionEnabled:(BOOL)enabled
{
    if (HUD) {
        HUD.userInteractionEnabled = enabled;
    }
}

+ (void)setDimBackground:(BOOL)enabled
{
    if (HUD) {
        HUD.dimBackground = enabled;
    }
}

@end
