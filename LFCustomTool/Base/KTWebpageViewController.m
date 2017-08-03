//
//  KTWebpageViewController.m
//  KTUAV_manager
//
//  Created by 刘丰 on 2017/6/12.
//  Copyright © 2017年 kaituo. All rights reserved.
//

#import "KTWebpageViewController.h"
#import <WebKit/WebKit.h>

#define LFProgressKey @"estimatedProgress"
@interface KTWebpageViewController ()<WKNavigationDelegate>

@property(nonatomic,weak) WKWebView *webView;

@property(nonatomic,weak) UIView *progressView;

@end

@implementation KTWebpageViewController

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] init];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        _webView = webView;
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _webView;
}

- (UIView *)progressView
{
    if (!_progressView) {
        UIView *progress = [[UIView alloc] init];
        progress.backgroundColor = kProgressColor;
        [self.view addSubview:progress];
        _progressView = progress;
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载网页
    [self loadWeb];
    //监听进度
    [self.webView addObserver:self forKeyPath:LFProgressKey options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadWeb
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:LFProgressKey]) {
        [self progress];
    }
}

- (void)progress
{
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.height.equalTo(@2);
        make.width.equalTo(self.view.mas_width).multipliedBy(self.webView.isLoading ? self.webView.estimatedProgress : 0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self loadWeb];
}

#pragma mark -
#pragma mark - WKNavigationDelegate
/*! 
 开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.webView.userInteractionEnabled = YES;
}

/*!
 加载失败
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.webView.userInteractionEnabled = NO;
    [LFNotification autoHideWithText:@"加载失败"];
}

/*! 
 加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.webView.userInteractionEnabled = YES;
    [self progress];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:LFProgressKey];
}

@end
