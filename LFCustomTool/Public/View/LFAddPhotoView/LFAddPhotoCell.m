//
//  LFAddPhotoCell.m
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFAddPhotoCell.h"

@interface LFAddPhotoCell ()

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) UIButton *deleteBtn;


@end

@implementation LFAddPhotoCell

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
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    _imageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    _deleteBtn = deleteBtn;
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    [self.deleteBtn setImage:[self.delegate addPhotoCellImageOfDelete:self] forState:UIControlStateNormal];
}

- (void)setDeleteHidden:(BOOL)deleteHidden
{
    _deleteHidden = deleteHidden;
    
    self.deleteBtn.hidden = deleteHidden;
}

#pragma mark -
#pragma mark - 删除
- (void)deleteImage:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addPhotoCellDidDelete:)]) {
        [self.delegate addPhotoCellDidDelete:self];
    }
}

@end
