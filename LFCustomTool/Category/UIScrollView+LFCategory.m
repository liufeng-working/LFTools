//
//  UIScrollView+LFCategory.m
//  KTUAV
//
//  Created by 刘丰 on 2017/11/3.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "UIScrollView+LFCategory.h"

@implementation UIScrollView (LFCategory)

+ (void)load {
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
