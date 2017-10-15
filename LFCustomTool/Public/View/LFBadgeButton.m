//
//  LFBadgeButton.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/17.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBadgeButton.h"

#define kFontSize [UIFont systemFontOfSize:(self.titleLabel.font.pointSize - 3)]
#define kDotSize 10
#define kMaxNum 99
@interface LFBadgeButton ()

@property(nonatomic,weak) UILabel *badgeLabel;

@end

@implementation LFBadgeButton

- (UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        UILabel *badge = [[UILabel alloc] init];
        badge.backgroundColor = [UIColor redColor];
        badge.textColor = [UIColor whiteColor];
        badge.font = kFontSize;
        badge.textAlignment = NSTextAlignmentCenter;
        badge.layer.masksToBounds = YES;
        badge.layer.borderColor = [UIColor redColor].CGColor;
        badge.layer.borderWidth = 1;;
        [self addSubview:badge];
        _badgeLabel = badge;
    }
    return _badgeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _type = LFBadgeButtonTypeNum;
        _position = LFBadgeButtonPositionTopRight;
        _offset = LFBadgeButtonOffsetNone;
    }
    return self;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    
    [self setNeedsLayout];
}

- (void)setType:(LFBadgeButtonType)type
{
    _type = type;
    
    [self setNeedsLayout];
}

- (void)setPosition:(LFBadgeButtonPosition)position
{
    _position = position;
    
    [self setNeedsLayout];
}

- (void)setOffset:(LFBadgeButtonOffset)offset
{
    _offset = offset;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.badge <= 0) {
        self.badgeLabel.hidden = YES;
        return;
    }
    
    CGFloat realW, realH, cornerRadius;
    switch (self.type) {
        case LFBadgeButtonTypeNum: {
            
            NSString *badgeStr = [self stringFromNSInteger:self.badge];
            if (self.badge > kMaxNum) {
                badgeStr = [NSString stringWithFormat:@"%@+", [self stringFromNSInteger:kMaxNum]];
            }
            
            CGSize badgeS = [self size:badgeStr];
            CGFloat badgeW = badgeS.width;
            CGFloat badgeH = badgeS.height;
            
            //只有1位时，显示成圆形
            if (badgeStr.length == 1) {
                CGFloat max = MAX(badgeW, badgeH);
                cornerRadius = max*0.5;
                realW = max;
                realH = max;
            }else {
                realW = badgeW + 5;
                realH = badgeH;
                cornerRadius = MIN(realW, realH)*0.5;
            }
            self.badgeLabel.text = badgeStr;
        }
            break;
            
        case LFBadgeButtonTypeDot: {
            realW = kDotSize;
            realH = realW;
            cornerRadius = realW*0.5;
        }
            break;
    }
    
    CGFloat hSpace/*横向留白*/, vSpace/*纵向留白*/;
    switch (self.offset) {
        case LFBadgeButtonOffsetNone: {
            hSpace = 0;
            vSpace = 0;
        }
            break;
            
        case LFBadgeButtonOffsetHalf: {
            hSpace = realW*0.5;
            vSpace = realH*0.5;
        }
            break;
        case LFBadgeButtonOffsetAll: {
            hSpace = realW;
            vSpace = realH;
        }
            break;
    }
    
    CGRect baseR;
    if (self.currentImage) {
        baseR = self.imageView.frame;
    }else if (self.currentTitle) {
        baseR = self.titleLabel.frame;
    }else {
        baseR = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    
    self.badgeLabel.hidden = NO;
    self.badgeLabel.layer.cornerRadius = cornerRadius;
    
    switch (self.position) {
        case LFBadgeButtonPositionTopRight:
            self.badgeLabel.frame = CGRectMake(CGRectGetMaxX(baseR) - realW + hSpace, CGRectGetMinY(baseR) - vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionTopRight_Left:
            self.badgeLabel.frame = CGRectMake(CGRectGetMidX(baseR) + (CGRectGetWidth(baseR) - realW)*0.25, CGRectGetMinY(baseR) - vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionTop:
            self.badgeLabel.frame = CGRectMake(CGRectGetMidX(baseR) - realW*0.5, CGRectGetMinY(baseR) - vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionTopLeft_Right:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) + (CGRectGetWidth(baseR) - realW)*0.25, CGRectGetMinY(baseR) - vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionTopLeft:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) - hSpace, CGRectGetMinY(baseR) - vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionTopLeft_Bottom:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) - hSpace, CGRectGetMinY(baseR) + (CGRectGetHeight(baseR) - realH)*0.25, realW, realH);
            break;
        case LFBadgeButtonPositionLeft:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) - hSpace, CGRectGetMidY(baseR) - realH*0.5, realW, realH);
            break;
        case LFBadgeButtonPositionBottomLeft_Top:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) - hSpace, CGRectGetMidY(baseR) + (CGRectGetHeight(baseR) - realH)*0.25, realW, realH);
            break;
        case LFBadgeButtonPositionBottomLeft:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) - hSpace, CGRectGetMaxY(baseR) - realH + vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionBottomLeft_Right:
            self.badgeLabel.frame = CGRectMake(CGRectGetMinX(baseR) + (CGRectGetWidth(baseR) - realW)*0.25, CGRectGetMaxY(baseR) - realH + vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionBottom:
            self.badgeLabel.frame = CGRectMake(CGRectGetMidX(baseR) - realW*0.5, CGRectGetMaxY(baseR) - realH + vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionBottomRight_Left:
            self.badgeLabel.frame = CGRectMake(CGRectGetMidX(baseR) + (CGRectGetWidth(baseR) - realW)*0.25, CGRectGetMaxY(baseR) - realH + vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionBottomRight:
            self.badgeLabel.frame = CGRectMake(CGRectGetMaxX(baseR) - realW + hSpace, CGRectGetMaxY(baseR) - realH + vSpace, realW, realH);
            break;
        case LFBadgeButtonPositionBottomRight_Top:
            self.badgeLabel.frame = CGRectMake(CGRectGetMaxX(baseR) - realW + hSpace, (CGRectGetMinY(baseR) - realH)*0.25, realW, realH);
            break;
        case LFBadgeButtonPositionRight:
            self.badgeLabel.frame = CGRectMake(CGRectGetMaxX(baseR) - realW + hSpace, CGRectGetMidY(baseR) - realH*0.5, realW, realH);
            break;
        case LFBadgeButtonPositionTopRight_Bottom:
            self.badgeLabel.frame = CGRectMake(CGRectGetMaxX(baseR) - realW + hSpace, (CGRectGetMidY(baseR) - realH)*0.25, realW, realH);
            break;
        case LFBadgeButtonPositionCenter:
            self.badgeLabel.frame = CGRectMake(CGRectGetMidX(baseR) - realW*0.5, CGRectGetMidY(baseR) - realH*0.5, realW, realH);
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    //去除高亮状态
}

- (NSString *)stringFromNSInteger:(NSInteger)number
{
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    return [NSString stringWithFormat:@"%ld", (long)number];
#else
    return [NSString stringWithFormat:@"%d", number];
#endif
}

- (CGSize)size:(NSString *)string
{
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, kFontSize.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontSize} context:nil].size;
}

@end
