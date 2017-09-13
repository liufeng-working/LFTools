//
//  UIView+LFCategory.h
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LFCategory)

/**
 *  x坐标
 */
@property (nonatomic, assign) CGFloat left;

/**
 *  y坐标
 */
@property (nonatomic, assign) CGFloat top;

/**
 *  右边位置
 */
@property (nonatomic, assign) CGFloat right;

/**
 *  下边位置
 */
@property (nonatomic, assign) CGFloat bottom;

/**
 *  高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  中心点x坐标
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *  中心点y坐标
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 *  位置信息
 */
@property (nonatomic, assign) CGPoint origin;

/**
 *  尺寸信息
 */
@property (nonatomic, assign) CGSize size;

/**
 自身的中心点坐标
 */
@property(nonatomic,assign,readonly) CGPoint boundsCenter;

/**
 *  把View加在Window上
 */
- (void)addToWindow;

/**
 *  是否包含某个子view
 */
- (BOOL)containsSubView:(UIView *)subView;

/**
 *  View截图
 */
- (UIImage *)snapshot;

/**
 *  View按指定大小截图
 */
- (UIImage *)snapshot:(CGRect)rect;

/**
 *  切角
 */
- (void)clipCorners;

/**
 *  切角（指定角）
 */
- (void)clipByCornerRadii:(CGSize)size
              withCorners:(UIRectCorner)corners;

/**
 *  爆炸效果
 */
- (void)BOOM;

/**
 *  该view的 控制器
 */
- (UIViewController *)viewController;

@end

IB_DESIGNABLE
@interface UIView (border)

@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;

@property(nonatomic,assign) IBInspectable CGFloat borderWidth;

@property(nonatomic,strong) IBInspectable UIColor *borderColor;

@end

@interface UIView (xib)

+(instancetype)lf_viewFromXib;

@end
