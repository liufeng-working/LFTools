//
//  LFPickerPhotoCell.m
//  KTUAV
//
//  Created by 刘丰 on 2017/8/29.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFPickerPhotoCell.h"
#import "LFPublicModel.h"
#import "LFPickerImageView.h"

@interface LFPickerPhotoCell ()

@property (weak, nonatomic) LFPickerImageView *imageView;

@property (weak, nonatomic) UIButton *deleteBtn;


@end

@implementation LFPickerPhotoCell

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
    LFPickerImageView *imageView = [[LFPickerImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    _imageView = imageView;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    _deleteBtn = deleteBtn;
    
    // 添加约束
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, deleteBtn);
    NSArray *ihC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:ihC];
    
    NSArray *ivC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:ivC];
    
    NSArray *bhC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[deleteBtn]-0-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:bhC];
    
    NSArray *bvC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[deleteBtn]" options:0 metrics:nil views:views];
    [self.contentView addConstraints:bvC];
}

- (void)setPublicM:(LFPublicModel *)publicM
{
    _publicM = publicM;
    
    self.imageView.image = publicM.image;
    
    [self.deleteBtn setImage:[self.delegate pickerPhotoCellImageOfDelete:self] forState:UIControlStateNormal];
    
    if (publicM.type == LFAssetMediaTypeGif) {
        self.imageView.type = LFPickerImageViewTypeGif1;
    }else if (publicM.type == LFAssetMediaTypeVideo){
        self.imageView.type = LFPickerImageViewTypeVideo;
    }else {
        self.imageView.type = LFPickerImageViewTypeNone;
    }
}

- (void)setDeleteHidden:(BOOL)deleteHidden
{
    _deleteHidden = deleteHidden;
    
    self.deleteBtn.hidden = deleteHidden;
}

#pragma mark -
#pragma mark - 删除
- (void)deleteImage:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(pickerPhotoCellDidDelete:)]) {
        [self.delegate pickerPhotoCellDidDelete:self];
    }
}

@end
