//
//  TopCell.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/8.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "TopCell.h"

@implementation TopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.totalMoneyByMoth.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.totalMoneyByMoth.layer.shadowOffset = CGSizeMake(5, 5);
    self.totalMoneyByMoth.layer.shadowRadius = 2.0f;
    self.totalMoneyByMoth.layer.shadowOpacity = 0.67f;
    
    self.subTitleLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.subTitleLabel.layer.shadowOffset = CGSizeMake(5, 5);
    self.subTitleLabel.layer.shadowOpacity = 0.67f;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
