//
//  SubtitleCell.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/12.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SubtitleCell.h"

@implementation SubtitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.categoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hImageWithTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[imageView(40)]" options:0 metrics:nil views:@{@"imageView":self.categoryImageView}];
    NSArray *vImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[imageView(40)]-6-|" options:0 metrics:nil views:@{@"imageView":self.categoryImageView}];
    [self.contentView addConstraints:hImageWithTitle];
    [self.contentView addConstraints:vImageView];
    
    
    NSArray *hTitleLAbel = [NSLayoutConstraint constraintsWithVisualFormat:@"[imageView]-15-[title(oneThrid)]" options:0 metrics:@{@"oneThrid":[NSNumber numberWithDouble:[UIScreen mainScreen].bounds.size.width/3]} views:@{@"imageView":self.categoryImageView,@"title":self.titleLabel}];
    NSArray *hSubTitleLAbel = [NSLayoutConstraint constraintsWithVisualFormat:@"[imageView]-15-[subTitle(oneThrid)]" options:0 metrics:@{@"oneThrid":[NSNumber numberWithDouble:[UIScreen mainScreen].bounds.size.width/3]} views:@{@"imageView":self.categoryImageView,@"subTitle":self.subTitleLabel}];
    [self.contentView addConstraints:hTitleLAbel];
    [self.contentView addConstraints:hSubTitleLAbel];
    
    NSArray *vTitleLAbel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[title(20)]-2-[subTitle(20)]-5-|" options:0 metrics:nil views:@{@"title":self.titleLabel,@"subTitle":self.subTitleLabel}];
    [self.contentView addConstraints:vTitleLAbel];
    
    NSArray *hdetailLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"[detail]-20-|" options:0 metrics:nil views:@{@"detail":self.detailLabel}];
    NSArray *vdetailLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[detail(40)]-6-|" options:0 metrics:nil views:@{@"detail":self.detailLabel}];
    [self.contentView addConstraints:hdetailLabel];
    [self.contentView addConstraints:vdetailLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
