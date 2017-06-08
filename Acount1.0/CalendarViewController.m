//
//  CalendarViewController.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/9.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "CalendarViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "OHMoneyRunContent.h"

@interface CalendarViewController ()<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>
{
    
    UIView *grayView;
    FSCalendar *calendar;
    NSCalendar *gregorianCalendar;
    
}

@end

@implementation CalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    grayView.backgroundColor = OHCalendarGrayAlphColor;//[UIColor colorWithRed:95/255.0 green:98/255.0 blue:99/255.0 alpha:0.3];//[[UIColor grayColor] colorWithAlphaComponent:0.5];
    
    calendar = [[FSCalendar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    
    calendar.delegate = self;
    calendar.dataSource = self;


    [calendar selectDate: self.today];
    calendar.appearance.selectionColor = [UIColor blueColor];
    
    
    calendar.backgroundColor = OHCalendarWhiteColor;
//    calendar.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    
    // Calendar text color
    calendar.appearance.headerTitleColor = OHCalendarGrayColor;
    calendar.appearance.weekdayTextColor = OHCalendarGrayColor;
    calendar.appearance.titleDefaultColor = OHCalendarGrayColor;
    
    // Calendar event background color
    calendar.appearance.todayColor = OhCalendarBlueColor;
    calendar.appearance.selectionColor = OHCalendarBrownColor;
    calendar.appearance.titleTodayColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    calendar.appearance.titleSelectionColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    
    [self.view addSubview:grayView];
    
    calendar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [grayView addSubview:calendar];
    NSArray *hCalendar = [NSLayoutConstraint constraintsWithVisualFormat:@"|[calendar]|" options:0 metrics:0 views:@{@"calendar":calendar}];
    NSArray *vCalendar = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[calendar(>=280)]|" options:0 metrics:0 views:@{@"calendar":calendar}];
    
    [UIView animateWithDuration:0.05 animations:^{
        
        [self.view addConstraints:hCalendar];
        [self.view addConstraints:vCalendar];
        [self.view layoutIfNeeded];
        
    }];
    

}

#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{

    if ([gregorianCalendar isDateInToday:date]) {
        return @"T";
    }
    return nil;
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    
    if ([gregorianCalendar isDateInToday:date]) {
//        return [UIImage imageNamed:@"list"];
    }
    return nil;
}



#pragma mark - FSCalendarDelegate
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterLongStyle];
    [dateFormat setTimeStyle:NSDateFormatterNoStyle];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *string = [dateFormat stringFromDate:date];
    NSLog(@"Date is %@", string);
    [self.delegate calendarViewController:self didSelectDate:date];
    
    [self->calendar selectDate:date];
    [NSThread sleepForTimeInterval:0.35];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    NSLog(@"boundingRectWillChange");
}


#pragma mark - FSCalendarDelegateAppearance

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {
    return [[UIColor whiteColor] colorWithAlphaComponent:1];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
