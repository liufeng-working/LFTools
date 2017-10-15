//
//  LFBaseViewController.h
//  Demo
//
//  Created by NJWC on 2016/12/5.
//  Copyright © 2016年 kaituo. All rights reserved.
//

/******************/
/** 所有控制器的基类 */
/******************/

#import <UIKit/UIKit.h>

@interface LFBaseViewController : UIViewController


/**
 检测网络变化

 @param noti 包含当前网络类型
 */
- (void)networkChange:(NSNotification *)noti;

@end
