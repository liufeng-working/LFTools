//
//  LFShowPhotoCell.m
//  KTUAV
//
//  Created by 刘丰 on 2017/9/14.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFShowPhotoCell.h"

@interface LFShowPhotoCell ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation LFShowPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    _imageView = imageView;
    
    // 添加约束
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:hC];
    
    NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:vC];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

- (void)setUrl:(NSURL *)url
{
    _url = url;
    
    [self.imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed];
}

@end
