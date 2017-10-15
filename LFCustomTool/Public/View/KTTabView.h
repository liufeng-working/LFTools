//
//  KTTabView.h
//  KTUAV
//
//  Created by 刘丰 on 2017/5/4.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTTabViewDelegate;
@interface KTTabView : UIView

/**
 在"- scrollViewDidScroll:"方法中，调用
 */
- (void)didScrollView:(UIScrollView *)scrollView;

@property(nonatomic,weak) id<KTTabViewDelegate> delegate;

/**
 标签名称
 */
@property(nonatomic,strong) NSArray<NSString *> *names;

/**
 选中某一个
 */
@property(nonatomic,assign) NSUInteger index;

/**
 默认字体颜色
 */
@property(nonatomic,strong) UIColor *normalColor;

/**
 选中字体颜色
 */
@property(nonatomic,strong) UIColor *selectColor;

/**
 滚动条颜色
 */
@property(nonatomic,strong) UIColor *barColor;

/**
 滚动条高度(最大为5，小于0则隐藏)
 */
@property(nonatomic,assign) CGFloat barHeight;

/**
 动画时间
 */
@property(nonatomic,assign) CGFloat duration;

/**
 隐藏底部分割线
 */
@property(nonatomic,assign) BOOL hideLine;

@end

@protocol KTTabViewDelegate <NSObject>

@optional
- (void)tabViewDidSelectTabAtIndex:(NSUInteger)index;

@end
