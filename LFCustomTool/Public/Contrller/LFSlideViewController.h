//
//  LFSlideViewController.h
//  test
//
//  Created by 刘丰 on 2016/12/28.
//  Copyright © 2016年 liufeng. All rights reserved.
//

/**************************/
//一个简单的仿QQ侧滑 只适用于竖屏
//一个简单的仿QQ侧滑 只适用于竖屏
//一个简单的仿QQ侧滑 只适用于竖屏
/**************************/
#import <UIKit/UIKit.h>

@interface LFSlideViewController : UINavigationController

/**
 初始化
 
 @param leftVC 左视图
 @param mainVC 主视图
 */
- (instancetype)initWithLeftViewController:(UIViewController *)leftVC
                        mainViewController:(UITabBarController *)mainVC;

/**
 关闭
 */
- (void)close;

/**
 打开
 */
- (void)open;

/**
 左控制器
 */
@property (nonatomic, strong, readonly) UIViewController *leftVC;

/**
 右控制器
 */
@property (nonatomic,strong, readonly) UITabBarController *mainVC;

/**
 设置拖动手势是否可用（当右视图存在push操作时，会造成手势返回冲突，此时应该禁用这个手势）
 */
- (void)panGestureRecognizerEnable:(BOOL)enable;

@end

/** 从侧边栏弹出的第一层ViewController都应该继承这个类 */
/** 从第二层ViewController开始，不要继承这个类。但是要在*/
/** viewDidLoad中加上如下两句，解决偏移问题           */
/** self.edgesForExtendedLayout = UIRectEdgeBottom;
 self.automaticallyAdjustsScrollViewInsets = NO; */
/** 继承这个类以后就可以直接使用[self.navigationController pushViewController:nextVC animated:YES]进行操作*/
/************************************************/

@interface LFBackViewController : UIViewController

/**
 从弹出的第一层返回侧边栏页面
 */
- (void)back;

@end
