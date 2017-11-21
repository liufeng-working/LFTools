//
//  LFBadgeButton.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/17.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LFBadgeButtonType) {
    LFBadgeButtonTypeNum = 0,
    LFBadgeButtonTypeDot,
    LFBadgeButtonTypeNew,
};

typedef NS_ENUM(NSInteger, LFBadgeButtonPosition) {
    LFBadgeButtonPositionTopRight = 0,
    LFBadgeButtonPositionTopRight_Left,
    LFBadgeButtonPositionTop,
    LFBadgeButtonPositionTopLeft_Right,
    LFBadgeButtonPositionTopLeft,
    LFBadgeButtonPositionTopLeft_Bottom,
    LFBadgeButtonPositionLeft,
    LFBadgeButtonPositionBottomLeft_Top,
    LFBadgeButtonPositionBottomLeft,
    LFBadgeButtonPositionBottomLeft_Right,
    LFBadgeButtonPositionBottom,
    LFBadgeButtonPositionBottomRight_Left,
    LFBadgeButtonPositionBottomRight,
    LFBadgeButtonPositionBottomRight_Top,
    LFBadgeButtonPositionRight,
    LFBadgeButtonPositionTopRight_Bottom,
    LFBadgeButtonPositionCenter,
};

typedef NS_ENUM(NSInteger, LFBadgeButtonOffset) {
    LFBadgeButtonOffsetNone = 0,
    LFBadgeButtonOffsetHalf,
    LFBadgeButtonOffsetAll,
};

typedef NS_ENUM(NSInteger, LFBadgeButtonAbove) {
    LFBadgeButtonAboveTitle = 0,
    LFBadgeButtonAboveImage,
    LFBadgeButtonAboveOut,
};

@interface LFBadgeButton : UIButton

/**
 badge个数(badge<=0隐藏；badge>0显示)
 */
@property(nonatomic,assign) IBInspectable NSInteger badge;

/**
 展示文字的label
 */
@property(nonatomic,weak,readonly) UILabel *badgeLabel;

/**
 背景
 */
@property(nonatomic,weak,readonly) UIImageView *backgroundView;

/**
 样式（默认LFBadgeButtonTypeDot）
 */
@property(nonatomic,assign) LFBadgeButtonType type;

/**
 位置（默认LFBadgeButtonPositionTopRight）
 */
@property(nonatomic,assign) LFBadgeButtonPosition position;

/**
 缩进(默认LFBadgeButtonInsetsHalf)
 */
@property(nonatomic,assign) LFBadgeButtonOffset offset;

/**
 在什么之上(默认LFBadgeButtonAboveTitle)
 */
@property(nonatomic,assign) LFBadgeButtonAbove above;

@end

NS_ASSUME_NONNULL_END
