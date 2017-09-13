//
//  LFCustom.h
//
//  Created by 刘丰 on 2017/5/26.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFCustom_h
#define LFCustom_h

#pragma mark -
#pragma mark - 一些视图
//登陆
#define kLogin kSB_InitialViewController(@"Login")
//主视图
#define kMain kSB_InitialViewController(@"Main")
//完善信息后的认证提醒
#define kAuth kSB_InitialViewController(@"Auth")

#pragma mark -
#pragma mark - 从storyboard获取viewController
/** 获取sb */
#define kStoryboard(storyboardName) [UIStoryboard storyboardWithName:storyboardName bundle:nil]
/** 从某个sb获取某个vc */
#define kSB_ViewController(storyboardName, className) [kStoryboard(storyboardName) instantiateViewControllerWithIdentifier:kClassName(className)]
/** 从某个sb获取主vc */
#define kSB_InitialViewController(storyboardName) [kStoryboard(storyboardName) instantiateInitialViewController]

#pragma mark -
#pragma mark - 执行控制器的segue
/** 执行控制器的segue */
#define kPerformSegue(className) \
[self performSegueWithIdentifier:kClassName(className) sender:nil];
#define kPerformSegue_sender(className, parameter) \
[self performSegueWithIdentifier:kClassName(className) sender:parameter];

#define kClassName(className) ((void)[className isKindOfClass:[NSObject class]], @#className)

#pragma mark -
#pragma mark - push操作
/** push到某个vc */
#define kPush(vcName) [self.navigationController pushViewController:vcName animated:YES]
/** push到某个sb的某个vc */
#define kPush_SB_ViewController(storyboardName, className) do {\
UIViewController *nextVC = kSB_ViewController(storyboardName, className);\
kPush(nextVC);\
} while (0)
/** push到某个sb的主vc */
#define kPush_SB_InitialViewController(storyboardName) do {\
UIViewController *nextVC = kSB_InitialViewController(storyboardName);\
kPush(nextVC);\
} while (0)

#pragma mark -
#pragma mark - 生成颜色
/** 生成颜色 */
//0XFFFFFF转UIColor
#define kUIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define kUIColorFromHex(hexValue) kUIColorFromHexWithAlpha(hexValue,1.0)
//(r,g,b,r)转UIColor
#define kUIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kUIColorFromRGB(r,g,b)    kUIColorFromRGBA(r, g, b, 1.0)
//随机颜色
#define kRandomColor kUIColorFromRGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)

#pragma mark -
#pragma mark - 判断版本
/** 判断版本 */
//当前版本
#define kSystemVersion [UIDevice currentDevice].systemVersion.floatValue
//版本是否相等
#define kVersionEqualTo(v) (kSystemVersion == (float)v)
//版本是否大于
#define kVersionGreater(v) (kSystemVersion > v)
//版本是否小于
#define kVersionLess(v) (kSystemVersion < v)
//版本是否大于等于
#define kVersionGreaterOrEqual(v) (kSystemVersion > v || kSystemVersion == (float)v)
//版本是否小于等于
#define kVersionLessOrEqual(v) (kSystemVersion < v || kSystemVersion == (float)v)
//ios8以上版本
#define iOS8Later kVersionGreaterOrEqual(8.0)
//ios9以上版本
#define iOS9Later kVersionGreaterOrEqual(9.0)
//ios10以上版本
#define iOS10Later kVersionGreaterOrEqual(10.0)

#pragma mark -
#pragma mark - 弱引用
/** 弱引用 */
#define kWeakSelf(weakSelf) __weak typeof(self) weakSelf = self

#pragma mark -
#pragma mark - 强引用
/** 强引用 */
#define kStrongSelf(strongSelf) __strong typeof(weakSelf) strongSelf = weakSelf


#endif /* LFCustom_h */
