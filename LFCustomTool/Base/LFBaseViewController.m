//
//  LFBaseViewController.m
//  Demo
//
//  Created by NJWC on 2016/12/5.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFBaseViewController.h"

@interface LFBaseViewController ()

@end

@implementation LFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    //解决向上偏移问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //自定义导航控制器返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //检测网络变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange:) name:LFReachabilityChangedNotification object:nil];
//    NSLog(@"%s", __func__);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //移除检测网络的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LFReachabilityChangedNotification object:nil];
//    NSLog(@"%s", __func__);
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - 子类实现这个方法
- (void)networkChange:(NSNotification *)noti
{
    //子类实现
}

-(void)dealloc {
    NSLog(@"%s", __func__);
    
    //移除检测网络的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LFReachabilityChangedNotification object:nil];
}

@end
