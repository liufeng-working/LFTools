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
 网络图片 url
 */
@property(nonatomic,strong,nullable) NSURL *imgUrl;

/****图片的地址****/
@property (nonatomic,copy,nullable)NSString * photoUrlStr;

/****点击图片跳转的链接****/
@property (nonatomic,copy,nullable)NSString * browserUrlStr;
/**
 本地图片
 */
@property(nonatomic,strong,nullable) UIImage *img;

/**
 图片标题
 */
@property(nonatomic,copy,nullable) NSString *title;

/**
 时间
 */
@property(nonatomic,copy,nullable) NSString *time;

/**
 新闻链接
 */
@property(nonatomic,strong,nullable) NSURL *htmlUrl;



+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl;
+ (instancetype)bannerModelWithImage:(UIImage *)img;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title
                                time:(NSString *)time;
+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time
                           htmlUrl:(NSURL *)htmlUrl;
+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title
                                time:(NSString *)time
                             htmlUrl:(NSURL *)htmlUrl;

@end
