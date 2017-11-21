//
//  LFAlbumCell.m
//  test
//
//  Created by 刘丰 on 2017/1/22.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#define lfTitleFont [UIFont boldSystemFontOfSize:17]
#define lfCountFont [UIFont systemFontOfSize:15]
#define lfSelectFont [UIFont systemFontOfSize:17]
#import "LFAlbumCell.h"
#import "LFImagePickerTool.h"
#import "LFImageManager.h"

@interface LFAlbumCell ()

@property(nonatomic,weak) UIImageView *iconImageView;

@property(nonatomic,weak) UILabel *titleLabel;

@property(nonatomic,weak) UILabel *countLabel;

@property(nonatomic,weak) UILabel *selectLabel;

@end

@implementation LFAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //相册缩略图
        UIImageView *icon = [[UIImageView alloc] init];
        icon.backgroundColor = [UIColor clearColor];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.layer.masksToBounds = YES;
        [self.contentView addSubview:icon];
        _iconImageView = icon;

        //相册名称
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor clearColor];
        title.font = lfTitleFont;
        [self.contentView addSubview:title];
        _titleLabel = title;
        
        //相册中图片数量
        UILabel *count = [[UILabel alloc] init];
        count.backgroundColor = [UIColor clearColor];
        count.font = lfCountFont;
        [self.contentView addSubview:count];
        _countLabel = count;
        
        //已选中图片数量
        UILabel *select = [[UILabel alloc] init];
        select.backgroundColor = [LFImagePickerTool colorWithHexString:@"#ff9c27"];
        select.textColor = [UIColor whiteColor];
        select.textAlignment = NSTextAlignmentCenter;
        select.layer.masksToBounds = YES;
        select.font = lfSelectFont;
        [self.contentView addSubview:select];
        _selectLabel = select;
    }
    return self;
}

+ (instancetype)albumCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"LFAlbumCell";
    LFAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LFAlbumCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)setAlbumM:(LFAlbumModel *)albumM
{
    _albumM = albumM;
    
    [[LFImageManager manager] thumbnail:albumM.assetMs.firstObject completion:^(UIImage *thumbnail, BOOL isThumbnail, LFAssetModel *model) {
        self.iconImageView.image = thumbnail;
    }];
    self.titleLabel.text = albumM.title;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", albumM.count];
    self.selectLabel.text = [NSString stringWithFormat:@"%zd", albumM.selectCount];
    self.selectLabel.hidden = albumM.selectCount <= 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    CGFloat midY = CGRectGetMidY(self.contentView.bounds);
    
    CGFloat selectH = lfSelectFont.lineHeight + 5;
    CGFloat selectW = selectH;
    CGFloat selectX = width - selectW;
    CGFloat selectY = midY - selectH*0.5;
    self.selectLabel.layer.cornerRadius = selectH*0.5;
    self.selectLabel.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    CGFloat iconX = 5;
    CGFloat iconY = 5;
    CGFloat iconH = height - iconY*2;
    CGFloat iconW = iconH;
    self.iconImageView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat titleX = CGRectGetMaxX(self.iconImageView.frame) + 10;
    CGFloat titleH = lfTitleFont.lineHeight;
    CGFloat titleY = midY - titleH - 2;
    CGFloat titleW = selectX - titleX - 10;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat countX = titleX;
    CGFloat countY = midY + 2;
    CGFloat countW = titleW;
    CGFloat countH = lfCountFont.lineHeight;
    self.countLabel.frame = CGRectMake(countX, countY, countW, countH);
}

@end
