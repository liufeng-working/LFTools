//
//  LFPlayerViewController.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/4/10.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPlayerViewController.h"

@interface LFPlayerViewController ()

@end

@implementation LFPlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

@end
