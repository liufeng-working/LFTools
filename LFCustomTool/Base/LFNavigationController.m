//
//  LFNavigationController.m
//  Ecology
//
//  Created by NJWC on 16/8/16.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFNavigationController.h"

@interface LFNavigationController ()<UIGestureRecognizerDelegate>

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
    
    UIPanGestureRecognizer *interactivePan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:NSSelectorFromString(@"handleNavigationTransition:")];
    interactivePan.delegate = self;
    [self.view addGestureRecognizer:interactivePan];
    
    self.interactivePopGestureRecognizer.enabled = NO;
}

//push时，隐藏底部TabBar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backBarButtonItemWithTarget:self action:@selector(back) image:[UIImage originalImageNamed:@"navigationButtonReturn"] highlightedImage:[UIImage originalImageNamed:@"navigationButtonReturnClick"] color:[UIColor blackColor] highlightedColor:[UIColor redColor] title:@"返回"];
    }
    
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count;
    [super pushViewController:viewController animated:animated];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.viewControllers.count != 1;
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}

@end
