//
//  LFNavigationController.m
//  Ecology
//
//  Created by NJWC on 16/8/16.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFNavigationController.h"

@interface LFNavigationController ()

@end

@implementation LFNavigationController

+ (void)initialize {
    //背景色
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#14A6DE"]];

    //中心标题
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
         NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    //左右UIBarButtonItem颜色(对自定义无效)
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //修改导航栏返回按钮的图片
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"nav_back"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"nav_back"];
    
    //左右UIBarButtonItem字体颜色(对自定义无效)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    //去除底部分割线
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#14A6DE"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.translucent = NO;
}

//push时，隐藏底部TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
