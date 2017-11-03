//
//  LFExtraView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFExtraView.h"
#import "Masonry.h"

@interface LFExtraView ()

@property(nonatomic,weak) UILabel *titleLabel;

@end

@implementation LFExtraView

#pragma mark -
#pragma mark - 懒加载控件
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
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
