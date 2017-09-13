//
//  LFBannerModel.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBannerModel.h"

@implementation LFBannerModel

//替换
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    /* photoUrl = "/group1/M00/00/11/wKjIXlmlC66APC3cAAt3SOtugpY946.png";
     title = "\Ufffd";
     type = 1;
     url = "http://www.wuxi.gov.cn/";*/
    
    return @{@"browserUrlStr":@"url",
             @"title":@"title",
             @"photoUrlStr":@"photoUrl"
             };
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
{
    return [self bannerModelWithUrl:imgUrl title:nil];
}

+ (instancetype)bannerModelWithImage:(UIImage *)img
{
    return [self bannerModelWithImage:img title:nil];
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
{
    return [self bannerModelWithUrl:imgUrl title:title time:nil];
}

+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title
{
    return [self bannerModelWithImage:img title:title time:nil];
}

+ (instancetype)bannerModelWithUrl:(NSURL *)imgUrl
                             title:(NSString *)title
                              time:(NSString *)time
{
    return [self bannerModelWithUrl:imgUrl title:title time:time htmlUrl:nil];
}

+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title
                                time:(NSString *)time
{
    return [self bannerModelWithImage:img title:title time:time htmlUrl:nil];
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

+ (instancetype)bannerModelWithImage:(UIImage *)img
                               title:(NSString *)title
                                time:(NSString *)time
                             htmlUrl:(NSURL *)htmlUrl
{
    LFBannerModel *banner = [LFBannerModel new];
    banner.img = img;
    banner.title = title;
    banner.time = time;
    banner.htmlUrl = htmlUrl;
    return banner;
}

-(NSURL *)imgUrl{

    if (self.photoUrlStr) {
        return [NSURL URLWithString:[kBaseUrlPhotoBrowseHeader stringByAppendingString:self.photoUrlStr]];
    }
    return _imgUrl;
}

-(NSURL *)htmlUrl{
    if (self.browserUrlStr) {
        return [NSURL URLWithString:[kBaseUrlPhotoBrowseHeader stringByAppendingString:self.browserUrlStr]];
    }
    return _htmlUrl;
}
@end
