//
//  SectionHeaderView.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/9.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
 */

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.detailLabel = [UILabel new];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:193/255.0 green:189/255.0 blue:184/255.0 alpha:0.3].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextMoveToPoint(context, self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 30, self.frame.size.height/2); //start at this point
    
    CGContextAddLineToPoint(context, self.detailLabel.frame.origin.x - 18, self.bounds.size.height/2); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
    
}


@end
