//
//  AnalysisTableViewCell.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/7.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisTableViewCell.h"

@implementation AnalysisTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.monthLabel = [UILabel new];
        [self.contentView addSubview:self.monthLabel];
        [self setMonthLabelStyle:self.monthLabel];
        
        
        self.moneyLabel = [UILabel new];
        [self.contentView addSubview:self.moneyLabel];
        [self setMoneyLabelStyle:self.moneyLabel];
        
        [self setConstrains];
        
        
        
    }
    return self;
    
}

- (void) setConstrains {
    
    // Month Label
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.monthLabel.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.monthLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8].active = YES;
    [self.monthLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:3].active = YES;
    [self.monthLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-3].active = YES;
    

    // Money Label
    self.moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.moneyLabel.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.moneyLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8].active = YES;
    [self.moneyLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:3].active = YES;
    [self.moneyLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-3].active = YES;
    
}

- (void) setMonthLabelStyle:(UILabel *) sender{
    [sender setFont:[UIFont systemFontOfSize:16]];
}

- (void) setMoneyLabelStyle:(UILabel *) sender {
    
    sender.textAlignment = UIControlContentHorizontalAlignmentRight;
    [sender setFont:[UIFont systemFontOfSize:16]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
