//
//  LFTopView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFTopView.h"

@interface LFTopView ()

@property(nonatomic,weak) UILabel *titleLabel;

@end

@implementation LFTopView

#pragma mark -
#pragma mark - 懒加载控件
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:self.bounds];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleL];
        _titleLabel = titleL;
    }
    return _titleLabel;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)currentIndex, (long)self.totle];
}

@end
