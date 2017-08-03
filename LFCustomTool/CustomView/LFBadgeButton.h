//
//  LFBadgeButton.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/17.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface LFBadgeButton : UIButton

/**
 badge个数(badge<=0隐藏；badge>0显示)
 */
@property(nonatomic,assign) NSInteger badge;

/**
 样式（默认LFBadgeButtonTypeNum）
 */
@property(nonatomic,assign) LFBadgeButtonType type;

/**
 位置（默认LFBadgeButtonPositionTopRight）
 */
@property(nonatomic,assign) LFBadgeButtonPosition position;

/**
 缩进（默认LFBadgeButtonInsetsNone）
 */
@property(nonatomic,assign) LFBadgeButtonOffset offset;

@end
