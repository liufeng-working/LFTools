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
 图片地址（二选一）
 */
@property(nonatomic,copy) NSString *imgStr;
@property(nonatomic,strong) NSURL *imgUrl;

/**
 视频url（如果是视频）
 */
@property(nonatomic,strong) NSURL *videoUrl;

/**
 是否是视频
 */
@property(nonatomic,assign,readonly) BOOL isVideo;

/**
 *  原始imageView（可选）
 */
@property (nonatomic,strong) UIImageView *sourceImageView;

/**
 占位图片（可选）
 */
@property(nonatomic,strong) UIImage *placeholderImage;

/**
 索引（可选）
 */
@property(nonatomic,assign) NSInteger index;

/**
 图片描述信息（可选）
 */
@property(nonatomic,copy) NSString *desc;

@end
