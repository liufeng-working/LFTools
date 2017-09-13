//
//  LFBannerCell.m
//  LFJXStreet
//
//  Created by 刘丰 on 2017/1/12.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFBannerCell.h"
#import "LFBannerModel.h"
#import "UIImageView+WebCache.h"

@interface LFBannerCell ()

@property(nonatomic,weak) UIImageView *imageView;

@end

@implementation LFBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
        _imageView.backgroundColor = kBackColor;
        _imageView = imageView;
    }
    return self;
}

- (void)setBannerModel:(LFBannerModel *)bannerModel
{
    _bannerModel = bannerModel;
    
    if (bannerModel.img) {
        self.imageView.image = bannerModel.img;
    }else {
        self.imageView.contentMode = UIViewContentModeCenter;
        
        [self.imageView sd_setImageWithURL:bannerModel.imgUrl placeholderImage:[UIImage imageNamed:@"bannerPlaceHolder_icon"]  options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.imageView.contentMode = UIViewContentModeScaleToFill;

        }];
    }
}

@end
