//
//  LFPhotoModel.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFPhotoModel : NSObject

/**
 网络图片
 */
@property(nonatomic,strong) NSURL *imgUrl;

/**
 本地图片
 */
@property(nonatomic,strong) UIImage *image;

/**
 占位图片（可选）
 */
@property(nonatomic,strong) UIImage *placeholderImage;

/**
 索引（可选）
 */
@property(nonatomic,assign) NSInteger index;

@end
