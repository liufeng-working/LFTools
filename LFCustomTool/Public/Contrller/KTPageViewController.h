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
 2.实现代理方法
 */

#import <UIKit/UIKit.h>

@protocol KTPageDelegate <NSObject>

@required
- (NSInteger)tabCount;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSString *)tabTitleAtIndex:(NSUInteger)index;

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

@property(nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,assign) BOOL scrollEnable;

- (void)reloadData;

@end

