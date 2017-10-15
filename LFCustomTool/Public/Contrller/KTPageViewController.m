//
//  KTPageViewController.m
//  KTUAV_manager
//
//  Created by 刘丰 on 2017/6/7.
//  Copyright © 2017年 kaituo. All rights reserved.
//

#import "KTPageViewController.h"
#import "KTTabView.h"

@interface KTPageViewController ()<KTTabViewDelegate, UIScrollViewDelegate>

@property(nonatomic,weak) KTTabView *topView;

@property(nonatomic,weak) UIScrollView *contentView;

@property(nonatomic,strong) NSMutableArray<UIViewController *> *viewControllers;

@end

@implementation KTPageViewController

- (KTTabView *)topView
{
    if (!_topView) {
        KTTabView *top = [[KTTabView alloc] init];
        top.delegate = self;
        top.backgroundColor = kNavColor;
        top.selectColor = [UIColor colorWithHexString:@"#FFDE00"];
        top.normalColor = [UIColor whiteColor];
        top.barColor = [UIColor colorWithHexString:@"#FFDE00"];
        [self.view addSubview:top];
        _topView = top;
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@(kCustomNavHeight));
        }];
    }
    return _topView;
}

- (UIScrollView *)contentView
{
    if (!_contentView) {
        UIScrollView *content = [[UIScrollView alloc] init];
        content.delegate = self;
        content.showsVerticalScrollIndicator = NO;
        content.showsHorizontalScrollIndicator = NO;
        content.pagingEnabled = YES;
        content.bounces = NO;
        content.delaysContentTouches = YES;
        content.canCancelContentTouches = NO;
        [self.view addSubview:content];
        _contentView = content;
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _contentView;
}

- (NSMutableArray<UIViewController *> *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self reloadData];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex <= 0) {
        _selectIndex = 0;
    }else if (selectIndex >= self.delegate.tabCount) {
        _selectIndex = self.delegate.tabCount;
    }else {
        _selectIndex = selectIndex;
    }
    
    [self.topView setIndex:_selectIndex];
    [self tabViewDidSelectTabAtIndex:_selectIndex];
}

- (void)setScrollEnable:(BOOL)scrollEnable
{
    _scrollEnable = scrollEnable;
    
    self.contentView.scrollEnabled = scrollEnable;
}

- (void)reloadData
{
    if (self.topView.names.count) {
        return;
    }
    
    [self addChildViewController];
    [self setupTab];
}

- (void)addChildViewController
{
    NSInteger count = self.delegate.tabCount;
    for (NSInteger i = 0; i < count; i ++) {
        UIViewController *childVC = [self.delegate viewControllerAtIndex:i];
        [self addChildViewController:childVC];
        [self.viewControllers addObject:childVC];
    }
    
    self.contentView.contentSize = CGSizeMake(count*CGRectGetWidth(self.view.frame), 0);
}

- (void)setupTab
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.delegate.tabCount];
    for (NSInteger i = 0; i < self.delegate.tabCount; i ++) {
        [titles addObject:[self.delegate tabTitleAtIndex:i]];
    }
    self.topView.names = titles;
    
    if ([self.delegate respondsToSelector:@selector(tabBackgroundColor)]) {
        self.topView.backgroundColor = [self.delegate tabBackgroundColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(tabNormalColor)]) {
        self.topView.normalColor = [self.delegate tabNormalColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(tabSelectClolor)]) {
        self.topView.selectColor = [self.delegate tabSelectClolor];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollBarColor)]) {
        self.topView.barColor = [self.delegate scrollBarColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollBarHeight)]) {
        self.topView.barHeight = [self.delegate scrollBarHeight];
    }
    
    if ([self.delegate respondsToSelector:@selector(duration)]) {
        self.topView.duration = [self.delegate duration];
    }
}

- (void)addChildView:(NSUInteger)index
{
    UIViewController *childVC = self.viewControllers[index];
    if (childVC.isViewLoaded) { return; }
    childVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:childVC.view];
}

#pragma mark -
#pragma mark - KTTabViewDelegate
- (void)tabViewDidSelectTabAtIndex:(NSUInteger)index
{
    CGFloat offsetX = CGRectGetWidth(self.view.frame)*index;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    [self addChildView:index];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    [self.topView setIndex:index];
    [self addChildView:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.topView didScrollView:scrollView];
}

#pragma mark -
#pragma mark - KTPageDelegate
- (NSInteger)tabCount
{
    NSAssert(NO, @"%@必须实现协议方法\'- tabCount\'", self.class);
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSAssert(NO, @"%@必须实现协议方法\'- viewControllerAtIndex:\'", self.class);
    return nil;
}

- (NSString *)tabTitleAtIndex:(NSUInteger)index
{
    NSAssert(NO, @"%@必须实现协议方法\'- tabTitleAtIndex:\'", self.class);
    return  nil;
}

@end
