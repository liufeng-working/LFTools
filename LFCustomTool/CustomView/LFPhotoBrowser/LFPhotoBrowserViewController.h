//
//  LFPhotoBrowserViewController.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFPhotoModel.h"

@interface LFPhotoBrowserViewController : UICollectionViewController

/**
 图片数组
 */
@property(nonatomic,strong) NSArray <LFPhotoModel *>*photos;

/**
 当前显示的索引
 */
@property(nonatomic,assign) NSInteger currentIndex;

/**
 显示图片浏览器
 */
- (void)show;

@end
