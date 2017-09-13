//
//  LFWebViewController.m
//  BuDeJie
//
//  Created by 刘丰 on 2017/8/10.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFWebViewController.h"
#import <WebKit/WebKit.h>

#define lf_estimatedProgress @"estimatedProgress"
#define lf_title @"title"
@interface LFWebViewController ()<WKNavigationDelegate>

@property(nonatomic,weak) WKWebView *webView;

@property (weak, nonatomic) UIProgressView *progressView;

@end

@implementation LFWebViewController

- (WKWebView *)webView
{
    if (!_webView) {
        WKPreferences *preference = [[WKPreferences alloc] init];
        preference.minimumFontSize = 17;
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        if ([NSBundle mainBundle].version.floatValue > 10.0) {
            configuration.ignoresViewportScaleLimits = self.zoomEnable;
        }
        configuration.preferences = preference;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            [self makeWebViewConstraints:make];
        }];
        _webView = webView;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        UIProgressView *progress = [[UIProgressView alloc] init];
        progress.tintColor = [UIColor redColor];
        [self.view addSubview:progress];
        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
            [self makeProgressViewConstraints:make];
        }];
        _progressView = progress;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.webView addObserver:self forKeyPath:lf_estimatedProgress options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:lf_title options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize
{
    _minimumFontSize = minimumFontSize;
    
    self.webView.configuration.preferences.minimumFontSize = minimumFontSize;
}

#pragma mark -
#pragma mark - 刷新
- (void)refresh
{
    [self.webView reload];
}

#pragma mark -
#pragma mark - 添加约束
- (void)makeWebViewConstraints:(MASConstraintMaker *)webView
{
    webView.edges.equalTo(self.view);
}

- (void)makeProgressViewConstraints:(MASConstraintMaker *)progressView
{
    progressView.top.left.right.equalTo(self.webView);
    progressView.height.equalTo(@2);
}

#pragma mark -
#pragma mark - 加载失败调用
- (void)loadFail:(NSError *)error
{
    if (error.code == NSURLErrorNotConnectedToInternet) {
        [LFNotification autoHideWithText:@"网络异常"];
    }else {
        [LFNotification autoHideWithText:@"加载失败"];
    }
}

#pragma mark -
#pragma mark - 加载完成时调用
- (void)loadFinish
{
}

#pragma mark -
#pragma mark - 网页的标题
- (void)webViewTitle:(NSString *)title
{
    self.title = title;
}

#pragma mark -
#pragma mark - 手势缩放是否可用
- (BOOL)zoomEnable
{
    return NO;
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:lf_title]) {
        [self webViewTitle:self.webView.title];
    }
    
    if ([keyPath isEqualToString:lf_estimatedProgress]) {
        self.progressView.progress = self.webView.estimatedProgress;
        self.progressView.hidden = self.webView.estimatedProgress == 1;
    }
}

#pragma mark -
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self loadFail:error];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self loadFinish];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:lf_estimatedProgress];
    [self.webView removeObserver:self forKeyPath:lf_title];
}

@end
