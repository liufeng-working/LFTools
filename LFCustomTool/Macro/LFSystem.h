//
//  KTSystem.h
//
//  Created by 刘丰 on 2017/5/26.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFSystem_h
#define LFSystem_h

#pragma mark -
#pragma mark - 屏幕宽高
/** 屏幕宽高 */
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#pragma mark -
#pragma mark - 主窗口
/** 主窗口 */
#define kWindow ([UIApplication sharedApplication].delegate.window)

#pragma mark -
#pragma mark - 主程序
/** 主程序代理 */
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark -
#pragma mark - 主程序
/** 主程序 */
#define kApplication [UIApplication sharedApplication]

#pragma mark -
#pragma mark - 用户偏好设置
/** 用户偏好设置 */
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#pragma mark -
#pragma mark - 通知中心
/** 通知中心 */
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#endif /* LFSystem_h */
