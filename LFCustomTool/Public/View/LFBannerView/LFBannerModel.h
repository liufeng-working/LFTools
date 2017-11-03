//
//  LFBannerModel.h
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFBannerModel : NSObject

/**
 网络图片 url
 */
@property(nonatomic,strong) NSURL *imgUrl;

/****图片的地址****/
@property (nonatomic,copy)NSString * photoUrlStr;

/****点击图片跳转的链接****/
@property (nonatomic,copy)NSString * browserUrlStr;

/**
 本地图片
 */
@property(nonatomic,strong) UIImage *img;

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
+ (instancetype)bannerModelWithImage:(UIImage *)img;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(nullable NSString *)title;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(nullable NSString *)title;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(nullable NSString *)title
                              time:(nullable NSString *)time;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(nullable NSString *)title
                                time:(nullable NSString *)time;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(nullable NSString *)title
                              time:(nullable NSString *)time
                           htmlUrl:(nullable NSURL *)htmlUrl;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(nullable NSString *)title
                                time:(nullable NSString *)time
                             htmlUrl:(nullable NSURL *)htmlUrl;

@end

NS_ASSUME_NONNULL_END
