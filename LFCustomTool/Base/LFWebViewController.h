//
//  LFWebViewController.h
//  BuDeJie
//
//  Created by 刘丰 on 2017/8/10.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFWebViewController : UIViewController

/**
 链接地址
 */
@property(nonatomic,strong) NSURL *url;

/**
 字体大小(默认17)
 */
@property(nonatomic,assign) CGFloat minimumFontSize;

/**
 刷新
 */
- (void)refresh;

/**************子类重写这些方法(可以不重写，有默认实现)***************/

/**
 添加控件的约束（依赖于Masonry框架）
 */
- (void)makeWebViewConstraints:(MASConstraintMaker *)webView;
- (void)makeProgressViewConstraints:(MASConstraintMaker *)progressView;

/**
 加载失败时调用
 */
- (void)loadFail:(NSError *)error;

/**
 加载完成时调用
 */
- (void)loadFinish;

/**
 网页的标题
 */
- (void)webViewTitle:(NSString *)title;

/**
 手势缩放是否可用（默认NO）
 */
- (BOOL)zoomEnable API_AVAILABLE(ios(10.0));

@end
