//
//  AnalysisTableViewCell.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/7.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisTableViewCell.h"
#import "OHMoneyRunContent.h"
@implementation AnalysisTableViewCell{
    CGSize monthSize;
    CGPoint monthPoint;
    CGPoint moneyPoint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.monthLabel = [UILabel new];
        [self.contentView addSubview:self.monthLabel];
        [self setMonthLabelStyle:self.monthLabel];
        
        self.moneyLabel = [UILabel new];
        [self.contentView addSubview:self.moneyLabel];
        [self setMoneyLabelStyle:self.moneyLabel];
    
        [self setConstrains];
        
    }
    [self setNeedsDisplay];
    return self;
    
}

- (void) setConstrains {
    
    // Month Label
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.monthLabel.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.monthLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:5].active = YES;
    [self.monthLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:3].active = YES;
    [self.monthLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-3].active = YES;
    

    // Money Label
    self.moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.moneyLabel.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.moneyLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15].active = YES;
    [self.moneyLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:3].active = YES;
    [self.moneyLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-3].active = YES;
    
}

- (void) setMonthLabelStyle:(UILabel *) sender{
    [sender setFont:[UIFont systemFontOfSize:16]];
    sender.textAlignment = UIControlContentHorizontalAlignmentRight;
}

- (void) setMoneyLabelStyle:(UILabel *) sender {
    
    sender.textAlignment = UIControlContentHorizontalAlignmentRight;
    [sender setFont:[UIFont systemFontOfSize:16]];
    
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    
    monthSize = self.monthLabel.frame.size;
    monthPoint = self.monthLabel.frame.origin;
    moneyPoint = self.moneyLabel.frame.origin;
    
    // Draw Line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:75/255.0 green:78/255.0 blue:79/255.0 alpha:1].CGColor);
    
    CGContextSetLineWidth(context, 1.6f);
    CGContextMoveToPoint(context, monthPoint.x + monthSize.width + 18, 0.0f);
    CGContextAddLineToPoint(context, monthPoint.x + monthSize.width + 18, self.contentView.frame.size.height);
    CGContextStrokePath(context);
    
    // Draw rectangle
    
    CGFloat x = monthPoint.x + monthSize.width + 18*2 + 1.6;
    CGFloat y = 11;
    
    CGRect rectangle =
    CGRectMake(x, y , self.rectangleWidth * (moneyPoint.x - x), 22);
    
    CGContextRef rectangleContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(rectangleContext, 0.5, 0.5, 0.5, 0.5);
    CGContextFillRect(rectangleContext, rectangle);
    
    
}

- (void) drawRectangel:(CGFloat) width {
    
    

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
