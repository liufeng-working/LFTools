//
//  LFPublicModel.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/3/1.
//  Copyright © 2017年 liufeng. All rights reserved.
/************************************************************/
/** 供外界展示图像时使用的模型类 */
/************************************************************/

#import <UIKit/UIKit.h>
#import "LFAssetModel.h"

@interface LFPublicModel : NSObject

/**
 图片
 */
@property(nonatomic,strong,readonly) UIImage *image;

/**
 图片的本质类型
 */
@property(nonatomic,assign,readonly) LFAssetMediaType type;

- (instancetype)initWithImage:(UIImage *)image
                         type:(LFAssetMediaType)type;
+ (instancetype)publicModelWithImage:(UIImage *)image
                                type:(LFAssetMediaType)type;

@end
