//
//  LFRunLabel.h
//  KT_Anhui
//
//  Created by NJWC on 16/9/29.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFRunLabel : UIView

@property (nonatomic, strong)NSString *text;

@property (nonatomic, strong)UIFont *font;

@property (nonatomic, strong)UIColor *textColor;

/**
 打开／销毁定时器
 */
- (void)fire;
- (void)invalidate;

@end
