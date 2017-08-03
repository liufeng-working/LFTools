//
//  KTPageViewController.h
//  KTUAV_manager
//
//  Created by 刘丰 on 2017/6/7.
//  Copyright © 2017年 kaituo. All rights reserved.
//

/**
 用法：
 1.继承KTPageViewController
 3.实现代理方法
 */

#import <UIKit/UIKit.h>

@protocol KTPageDelegate <NSObject>

@required
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSArray<NSString *> *)tabTitles;

@optional
- (UIColor *)tabBackgroundColor;
- (UIColor *)tabNormalColor;
- (UIColor *)tabSelectClolor;
- (UIColor *)scrollBarColor;
- (CGFloat)scrollBarHeight;
- (CGFloat)duration;

@end

@interface KTPageViewController : UIViewController<KTPageDelegate>

@property(nonatomic,weak) id<KTPageDelegate> delegate;

@end

