//
//  KTSystem.h
//  KTUAV
//
//  Created by 刘丰 on 2017/5/26.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef KTSystem_h
#define KTSystem_h

#pragma mark -
#pragma mark - 屏幕宽高
/** 屏幕宽高 */
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#pragma mark -
#pragma mark - 主窗口
/** 主窗口 */
#define kWindow ([UIApplication sharedApplication].delegate.window)

#pragma mark -
#pragma mark - 主程序
/** 主程序 */
#define kApp ((AppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark -
#pragma mark - 用户偏好设置
/** 用户偏好设置 */
#define kUserDefaults [NSUserDefaults standardUserDefaults]

#pragma mark -
#pragma mark - 通知中心
/** 通知中心 */
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#endif /* KTSystem_h */
