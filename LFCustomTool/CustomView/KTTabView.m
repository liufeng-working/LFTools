//
//  KTTabView.m
//  KTUAV
//
//  Created by 刘丰 on 2017/5/4.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "KTTabView.h"

#define kScale 1.0
@interface KTTabView ()

@property (weak, nonatomic) UIButton *currentTab;

/** 滚动条 */
@property (weak, nonatomic) UIView *scrollBar;

@property(nonatomic,weak) UIView *line;

@property(nonatomic,strong) NSMutableArray<UIButton *> *tabs;

@end

@implementation KTTabView

//懒加载
- (NSMutableArray<UIButton *> *)tabs
{
    if (!_tabs) {
        _tabs = [NSMutableArray array];
    }
    return _tabs;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultSetting];
        [self addSubview];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSetting];
        [self addSubview];
    }
    return self;
}

- (void)defaultSetting
{
    _index = 0;
    _normalColor = [UIColor whiteColor];
    _selectColor = [UIColor blackColor];
    _barColor = [UIColor blackColor];
    _barHeight = 3;
    _duration = 0.2;
}

- (void)addSubview
{
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self addSubview:line];
    _line = line;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    UIView *scrollBar = [UIView new];
    scrollBar.backgroundColor = self.barColor;
    [self addSubview:scrollBar];
    _scrollBar = scrollBar;
}

- (void)didScrollView:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.frame);
    if (!width) { return; }
    CGFloat curPage = scrollView.contentOffset.x/width;
    NSInteger leftIndex = curPage;
    NSInteger rightIndex = curPage + 1;
    UIButton *leftB = self.tabs[leftIndex];
    
    UIButton *rightB;
    if (rightIndex < self.tabs.count) {
        rightB = self.tabs[rightIndex];
    }
    
    CGFloat rightScale = curPage - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    CGFloat leftBmin = CGRectGetMinX(leftB.frame);
    CGFloat barLeft = leftBmin + (CGRectGetMinX(rightB.frame) - leftBmin)*rightScale;
    [self.scrollBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.barHeight));
        make.bottom.equalTo(self);
        make.width.equalTo(self.currentTab);
        make.left.equalTo(@(barLeft));
    }];
    
    CGFloat leftS = leftScale*(kScale - 1) + 1;
    CGFloat rightS = rightScale*(kScale - 1) + 1;
    leftB.transform = CGAffineTransformMakeScale(leftS, leftS);
    rightB.transform = CGAffineTransformMakeScale(rightS, rightS);
    
    CGFloat leftRed, leftGreen, leftBlue;
    CGFloat rightRed, rightGreen, rightBlue;
    [self.normalColor getRed:&leftRed green:&leftGreen blue:&leftBlue alpha:nil];
    [self.selectColor getRed:&rightRed green:&rightGreen blue:&rightBlue alpha:nil];
    
    leftB.titleLabel.textColor = [UIColor colorWithRed:leftRed + (rightRed - leftRed)*leftScale green:leftGreen + (rightGreen - leftGreen)*leftScale blue:leftBlue + (rightBlue - leftBlue)*leftScale alpha:1];
    rightB.titleLabel.textColor = [UIColor colorWithRed:leftRed + (rightRed - leftRed)*rightScale green:leftGreen + (rightGreen - leftGreen)*rightScale blue:leftBlue + (rightBlue - leftBlue)*rightScale alpha:1];
}

- (void)setNames:(NSArray<NSString *> *)names
{
    _names = names;
    
    if (!names.count) { return; }
    
    __block UIButton *lastBtn = nil;
    [names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.tabs addObject:btn];
       
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(self.mas_width).dividedBy(names.count);
            make.left.equalTo(lastBtn ? lastBtn.mas_right : @0);
        }];
        
        lastBtn = btn;
        
        if (idx == 0) {
            btn.selected = YES;
            btn.transform = CGAffineTransformMakeScale(kScale, kScale);
            self.currentTab = btn;
            if ([self.delegate respondsToSelector:@selector(tabViewDidSelectTabAtIndex:)]) {
                [self.delegate tabViewDidSelectTabAtIndex:btn.tag];
            }
        }
    }];
}

- (void)setIndex:(NSUInteger)index
{
    if (index > self.names.count) {
        _index = self.names.count;
    }else {
        _index = index;
    }
    
    UIButton *tab = self.tabs[index];
    [self changeTab:tab];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    [self.tabs enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:normalColor forState:UIControlStateNormal];
    }];
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    
    [self.tabs enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:selectColor forState:UIControlStateSelected];
    }];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    
    self.scrollBar.backgroundColor = barColor;
}

- (void)setBarHeight:(CGFloat)barHeight
{
    _barHeight = barHeight <= 5 ? barHeight : 5;
}

- (void)setHideLine:(BOOL)hideLine
{
    _hideLine = hideLine;
    
    self.line.hidden = hideLine;
}

- (void)switchTab:(UIButton *)sender {
    
    if (self.currentTab == sender) { return; }
    
    [self changeTab:sender];
    
    if ([self.delegate respondsToSelector:@selector(tabViewDidSelectTabAtIndex:)]) {
        [self.delegate tabViewDidSelectTabAtIndex:sender.tag];
    }
}

- (void)changeTab:(UIButton *)sender
{
    if (self.currentTab == sender) { return; }
    
    sender.selected = YES;
    self.currentTab.selected = NO;
    self.currentTab.transform = CGAffineTransformIdentity;
    self.currentTab = sender;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:self.duration animations:^{
        sender.transform = CGAffineTransformMakeScale(kScale, kScale);
        [self layoutIfNeeded];
    }];
}

- (void)updateConstraints
{
    if (self.currentTab) {
        [self.scrollBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.barHeight));
            make.bottom.equalTo(self);
            make.left.right.equalTo(self.currentTab);
        }];
    }
    
    [super updateConstraints];
}

@end
