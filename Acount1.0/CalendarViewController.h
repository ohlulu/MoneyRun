//
//  CalendarViewController.h
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/9.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CalendarViewControllerDelegate <NSObject>

- (void)calendarViewController:(UIViewController *)view didSelectDate:(NSDate *)date;

@end

@interface CalendarViewController : UIViewController


@property (nonatomic) NSDate *today;
@property (nonatomic, weak) id<CalendarViewControllerDelegate> delegate;

@end
