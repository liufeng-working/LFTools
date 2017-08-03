//
//  LFPublicModel.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/3/1.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPublicModel.h"

@implementation LFPublicModel

- (instancetype)initWithImage:(UIImage *)image
                         type:(LFAssetMediaType)type
{
    self = [super init];
    if (self) {
        _image = image;
        _type = type;
    }
    return self;
}

+ (instancetype)publicModelWithImage:(UIImage *)image
                                type:(LFAssetMediaType)type
{
    return [[self alloc] initWithImage:image type:type];
}

@end
