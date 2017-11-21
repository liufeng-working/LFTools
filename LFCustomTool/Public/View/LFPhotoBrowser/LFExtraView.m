//
//  LFExtraView.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFExtraView.h"

@interface LFExtraView ()

@property(nonatomic,weak) UILabel *titleL;

@property(nonatomic,weak) UIButton *saveB;

@end

@implementation LFExtraView

#pragma mark -
#pragma mark - 懒加载控件
- (UILabel *)titleL
{
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont boldSystemFontOfSize:17];
        titleL.userInteractionEnabled = NO;
        [self addSubview:titleL];
        _titleL = titleL;
        
        titleL.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(titleL);
        NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleL]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:hC];
        
        NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleL]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:vC];
    }
    return _titleL;
}

- (UIButton *)saveB
{
    if (!_saveB) {
        UIButton *saveB = [UIButton buttonWithType:UIButtonTypeCustom];
        saveB.hidden = YES;
        [saveB setTitle:@"保存" forState:UIControlStateNormal];
        [saveB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveB addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:saveB aboveSubview:self.titleL];
        _saveB = saveB;
        
        saveB.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(saveB);
        NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[saveB]-15-|" options:0 metrics:nil views:views];
        [self addConstraints:hC];
        
        NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[saveB]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:vC];
    }
    return _saveB;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    self.titleL.text = [NSString stringWithFormat:@"%zd/%zd", currentIndex, self.totle];
}

- (void)setSaveShow:(BOOL)saveShow
{
    _saveShow = saveShow;
    
    self.saveB.hidden = !saveShow;
}

#pragma mark -
#pragma mark - 点击保存
- (void)save
{
    if ([self.delegate respondsToSelector:@selector(extraViewDidClickSave:)]) {
        [self.delegate extraViewDidClickSave:self];
    }
}

@end
