//
//  LFBannerModel.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface LFBannerModel : NSObject

/**
 图片链接
 */
@property(nonatomic,strong) NSURL *imgUrl;

/**
 图片标题
 */
@property(nonatomic,copy) NSString *title;

/**
 时间
 */
@property(nonatomic,copy) NSString *time;

/**
 新闻链接
 */
@property(nonatomic,strong) NSURL *htmlUrl;

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time
                           htmlUrl:(NSURL *)htmlUrl;

@end
