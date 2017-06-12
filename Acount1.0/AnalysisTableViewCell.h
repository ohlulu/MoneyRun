//
//  AnalysisTableViewCell.h
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/7.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnalysisTableViewCell : UITableViewCell

@property (nonatomic) UILabel *monthLabel;
@property (nonatomic) UILabel *moneyLabel;
@property (nonatomic) CGFloat rectangleWidth;

- (void) drawRectangel:(CGFloat) width;

@end
