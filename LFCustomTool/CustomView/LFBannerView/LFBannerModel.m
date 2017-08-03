//
//  LFBannerModel.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBannerModel.h"

@implementation LFBannerModel

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
{
    return [self bannerModelWithUrl:imgUrl title:nil];
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
{
    return [self bannerModelWithUrl:imgUrl title:title time:nil];
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time
{
    return [self bannerModelWithUrl:imgUrl title:title time:time htmlUrl:nil];
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time
                           htmlUrl:(NSURL *)htmlUrl
{
    LFBannerModel *banner = [LFBannerModel new];
    banner.imgUrl = imgUrl;
    banner.title = title;
    banner.time = time;
    banner.htmlUrl = htmlUrl;
    return banner;
}

@end
