//
//  LFInvalidCell.m
//  KTUAV
//
//  Created by 刘丰 on 2017/11/8.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFInvalidCell.h"

@implementation LFInvalidCell

+ (instancetype)invalidCellWithTableView:(UITableView *)tableView
{
    static NSString *lfInvalidCell_id = @"LFInvalidCell";
    LFInvalidCell *cell = [tableView dequeueReusableCellWithIdentifier:lfInvalidCell_id];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lfInvalidCell_id];
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *invalidV = [[UIView alloc] init];
        invalidV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:invalidV];
        
        invalidV.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = NSDictionaryOfVariableBindings(invalidV);
        NSArray *hC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[invalidV]-0-|" options:0 metrics:nil views:views];
        NSArray *vC = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[invalidV(0)]-0-|" options:0 metrics:nil views:views];
        [self.contentView addConstraints:hC];
        [self.contentView addConstraints:vC];
    }
    return self;
}

@end
