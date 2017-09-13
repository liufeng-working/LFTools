//
//  UIView+LFCategory.m
//  test1
//
//  Created by NJWC on 16/8/31.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "UIView+LFCategory.h"
#import "UIImage+LFCategory.h"

@implementation UIView (LFCategory)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.left + self.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.top + self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)boundsCenter
{
    return CGPointMake(self.width / 2, self.height / 2);
}

/**
 *  把View加在Window上
 */
- (void)addToWindow
{
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
}

/**
 *  是否包含某个子view
 */
- (BOOL)containsSubView:(UIView *)subView
{
    for (UIView *view in self.subviews) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  View截图
 */
- (UIImage *)snapshot
{
    return [self snapshot:self.bounds];
}

/**
 *  View按指定大小截图
 */
- (UIImage *)snapshot:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  切角
 */
- (void)clipCorners
{
    [self clipByCornerRadii:CGSizeMake(10, 10) withCorners:UIRectCornerAllCorners];
}

/**
 *  切角（指定角）
 */
- (void)clipByCornerRadii:(CGSize)size
              withCorners:(UIRectCorner)corners
{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

static NSMutableArray<CALayer *> *_booms;
static const NSInteger count = 20;

/**
 *  爆炸效果
 */
- (void)BOOM
{
    //碎片化
    [self piece];
    
    //粉碎动画
    [self cellAnimation];
    
    //view消失动画
    [self removeFromSuperview];
}

/**
 *  该view的 控制器
 */
- (UIViewController *)viewController
{
    UIResponder *nextResponder = [self nextResponder];
    while (![nextResponder isKindOfClass:[UIViewController class]] && nextResponder) {
        nextResponder = [nextResponder nextResponder];
    }
    return nextResponder ? (UIViewController *)nextResponder : nil;
}

//碎片化
- (void)piece
{
    _booms = [NSMutableArray<CALayer *> array];
    CGFloat equal = MIN(self.width, self.height) / count;
    UIImage *image = [self screenshot];
    UInt8 *bitmapData = image.getBitmapData;
    
    for(NSInteger i = 0; i < count; i++) {
        for(NSInteger j = 0; j < count; j++) {
            
            CALayer *boomCell = [CALayer layer];
            boomCell.backgroundColor = [image colorAtPoint:CGPointMake(i*equal, j*equal) bitmapData:bitmapData].CGColor;
            boomCell.cornerRadius = equal/2.0;
            boomCell.frame = CGRectMake(self.left + i*equal, self.top + j*equal, equal, equal);
            [self.layer.superlayer addSublayer:boomCell];
            [_booms addObject:boomCell];
        }
    }
}

//每个layer的动画
-(void)cellAnimation
{
    for(CALayer *cell in _booms){
        
        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyframeAnimation.path = self.creatRandomPath.CGPath;
        keyframeAnimation.fillMode = kCAFillModeForwards;
        keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        keyframeAnimation.duration = random()%11*0.05 + 0.5;
        
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.toValue = @(random()%11*0.1);
        scale.duration = keyframeAnimation.duration;
        scale.removedOnCompletion = NO;
        scale.fillMode = kCAFillModeForwards;
        
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @1;
        opacity.toValue = @0;
        opacity.duration = keyframeAnimation.duration;
        opacity.removedOnCompletion = NO;
        opacity.fillMode = kCAFillModeForwards;
        opacity.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = keyframeAnimation.duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.animations = @[keyframeAnimation,scale,opacity];
        [cell addAnimation:animationGroup forKey: @"moveAnimation"];
    }
}

//绘制粉碎路径
- (UIBezierPath *)creatRandomPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.center];
    CGFloat left = -self.width * 1.3;
    CGFloat maxOffset = 2 * fabs(left);
    CGFloat randomNumber = random()%101;
    CGFloat endPointX = self.centerX + left + (randomNumber/100) * maxOffset;
    CGFloat endPointY = self.centerY + self.height/2 +random()%(int)(self.height/2);
    CGFloat controlPointOffSetX = self.centerX + (endPointX-self.centerX)/2;
    CGFloat controlPointOffSetY = self.centerY - 0.2 * self.height - random()%(int)(1.2 * self.height);
    
    [path addQuadCurveToPoint:CGPointMake(endPointX, endPointY) controlPoint:CGPointMake(controlPointOffSetX, controlPointOffSetY)];
    return path;
}

@end

@implementation UIView (border)

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

@end

@implementation UIView (xib)

+(instancetype)lf_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end

