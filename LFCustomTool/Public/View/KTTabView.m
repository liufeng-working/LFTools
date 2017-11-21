//
//  KTTabView.m
//  KTUAV
//
//  Created by 刘丰 on 2017/5/4.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "KTTabView.h"

@interface KTTabView ()

/** 滚动背景 */
@property(nonatomic,weak) UIScrollView *scrollView;

/** 当前选中标签 */
@property (weak, nonatomic) UIButton *currentTab;

/** 滚动条 */
@property (weak, nonatomic) UIView *scrollBar;

/** 分割线 */
@property(nonatomic,weak) UIView *line;

/** 所有标签 */
@property(nonatomic,strong) NSMutableArray<UIButton *> *tabs;

@end

@implementation KTTabView

/**
 懒加载
 */
- (NSMutableArray<UIButton *> *)tabs
{
    if (!_tabs) {
        _tabs = [NSMutableArray array];
    }
    return _tabs;
}

#pragma mark -
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
        [self addSubview];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self defaultSetting];
    [self addSubview];
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
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
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
    [scrollView addSubview:scrollBar];
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
    CGFloat leftBMax = CGRectGetMaxX(leftB.frame);
    CGFloat barLeft = leftBmin + (CGRectGetMinX(rightB.frame) - leftBmin)*rightScale;
    CGFloat barRight = leftBMax + (CGRectGetMaxX(rightB.frame) - leftBMax)*rightScale;
    [self.scrollBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.barHeight));
        make.bottom.equalTo(self);
        make.left.equalTo(@(barLeft));
        make.right.equalTo(@(barRight));
    }];
    
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
    
    //先计算总宽度
    __block CGFloat maxW = 0;
    NSMutableArray *nameWs = [NSMutableArray arrayWithCapacity:names.count];
    UIFont *font = [UIFont systemFontOfSize:17];
    [names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat nameW = [obj sizeWithFont:font].width + 20;
        [nameWs addObject:@(nameW)];
        maxW += nameW;
    }];
    
    CGFloat width = kScreenWidth;
    CGFloat height = kScreenHeight;
    self.scrollView.contentSize = CGSizeMake(maxW > width ? maxW : width, height);
    
    __block UIButton *lastBtn = nil;
    [names enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = idx;
        btn.titleLabel.font = font;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(switchTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.tabs addObject:btn];
       
        CGFloat itemW = [nameWs[idx] floatValue];
        if (maxW < width) {
            itemW += (width - maxW)/names.count;
        }
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@(itemW));
            make.left.equalTo(lastBtn ? lastBtn.mas_right : @0);
        }];
        
        lastBtn = btn;
    }];
    
    self.index = 0;
}

- (void)setIndex:(NSInteger)index
{
    if (index < 0) {
        _index = 0;
    }else if (index > self.names.count) {
        _index = self.names.count;
    }else {
        _index = index;
    }
    
    UIButton *tab = self.tabs[_index];
    [self changeTab:tab animation:NO];
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
    if (barHeight <= 0) {
        _barHeight = 0;
    }else if (barHeight >= 5) {
        _barHeight = 5;
    }else {
        _barHeight = barHeight;
    }
}

- (void)setHideLine:(BOOL)hideLine
{
    _hideLine = hideLine;
    
    self.line.hidden = hideLine;
}

- (void)switchTab:(UIButton *)sender {
    
    if (self.currentTab == sender) { return; }
    
    [self changeTab:sender animation:YES];
    
    if ([self.delegate respondsToSelector:@selector(tabViewDidSelectTabAtIndex:)]) {
        [self.delegate tabViewDidSelectTabAtIndex:sender.tag];
    }
}

- (void)changeTab:(UIButton *)sender animation:(BOOL)animation
{
    if (self.currentTab == sender) { return; }
    
    sender.selected = YES;
    self.currentTab.selected = NO;
    self.currentTab = sender;
    
    [self.scrollBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.barHeight));
        make.bottom.equalTo(self);
        make.left.right.equalTo(self.currentTab);
    }];
    if (animation) {
        [UIView animateWithDuration:self.duration animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self offsetAnimation];
        }];
    }else {
        [self layoutIfNeeded];
        [self offsetAnimation];
    }
}

- (void)offsetAnimation
{
    [UIView animateWithDuration:self.duration animations:^{
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        self.scrollView.contentOffset = CGPointMake(CGRectGetMidX(self.currentTab.frame) - width*0.5, 0);
        
        CGFloat offsetX = self.scrollView.contentOffset.x;
        if (offsetX <= 0) {
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        CGFloat maxOffset = self.scrollView.contentSize.width - width;
        if (offsetX >= maxOffset) {
            self.scrollView.contentOffset = CGPointMake(maxOffset, 0);
        }
    }];
}

@end
