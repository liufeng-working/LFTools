//
//  LFPhotoModel.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/11.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPhotoModel.h"

@implementation LFPhotoModel

- (void)setImgStr:(NSString *)imgStr
{
    _imgStr = imgStr;
    
    _imgUrl = [NSURL URLWithString:imgStr];
}

- (void)setImgUrl:(NSURL *)imgUrl
{
    _imgUrl = imgUrl;
    
    _imgStr = imgUrl.absoluteString;
}

- (void)setVideoUrl:(NSURL *)videoUrl
{
    _videoUrl = videoUrl;
    
    _isVideo = videoUrl.absoluteString.length != 0;
}

- (void)setSourceImageView:(UIImageView *)sourceImageView
{
    _sourceImageView = sourceImageView;
    
    _placeholderImage = sourceImageView.image;
}

@end
