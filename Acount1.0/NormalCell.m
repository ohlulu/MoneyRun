//
//  NormalCell.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/8.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "NormalCell.h"


@implementation NormalCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    self.categoryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
//    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self.contentView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
    
    NSArray *hImageWithTitle = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[imageView(40)]-15-[title(oneThrid)]" options:0 metrics:@{@"oneThrid":[NSNumber numberWithDouble:[UIScreen mainScreen].bounds.size.width/3]} views:@{@"imageView":self.categoryImageView,@"title":self.titleLabel}];
    NSArray *vImageView = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[imageView(40)]-6-|" options:0 metrics:nil views:@{@"imageView":self.categoryImageView}];
    [self.contentView addConstraints:hImageWithTitle];
    [self.contentView addConstraints:vImageView];
    
    NSArray *vTitleLAbel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title(40)]-6-|" options:0 metrics:nil views:@{@"title":self.titleLabel}];
    [self.contentView addConstraints:vTitleLAbel];
    
    NSArray *hdetailLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"[detail]-20-|" options:0 metrics:nil views:@{@"detail":self.detailLabel}];
    NSArray *vdetailLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[detail(40)]-6-|" options:0 metrics:nil views:@{@"detail":self.detailLabel}];
    [self.contentView addConstraints:hdetailLabel];
    [self.contentView addConstraints:vdetailLabel];
    
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

-(void)dealloc{
    
}

@end
