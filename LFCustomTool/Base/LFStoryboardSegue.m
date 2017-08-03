//
//  LFStoryboardSegue.m
//  Demo
//
//  Created by NJWC on 2016/12/6.
//  Copyright © 2016年 kaituo. All rights reserved.
//

#import "LFStoryboardSegue.h"

@implementation LFStoryboardSegue


/**
 重写父类方法
 */
- (void)perform {
    UIViewController *fromVC = self.sourceViewController;
    [fromVC dismissViewControllerAnimated:YES completion:nil];
}

@end
