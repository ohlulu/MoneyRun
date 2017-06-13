//
//  AnalysisDetailViewController.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/8.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisDetailViewController.h"
#import "OHMoneyRunContent.h"
#import "DataController.h"
@import Charts;
@import GoogleMobileAds;

@interface AnalysisDetailViewController () <ChartViewDelegate,IChartAxisValueFormatter,UIScrollViewDelegate>
{
    DataController *dc;
    __block NSMutableArray *pieChartEntries;
    __block NSMutableArray *barChartyValue;
    __block NSArray<NSString *> *xVauleLabel;
    NSInteger barDataCount;
    NSDateFormatter *formatMonth;
    NSDateFormatter *formatYear;
    NSCalendar *calendar;
}

@property (nonatomic) PieChartView *pieChartView;
@property (nonatomic) HorizontalBarChartView *barChartView;
@property (nonatomic) UIScrollView *scView;


@end

@implementation AnalysisDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_ADDBUTTON_NOTIFICATION object:nil];
    
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = OHCalendarWhiteColor;
    
    dc = [DataController sharedInstance];
    
    
    pieChartEntries = [NSMutableArray new];
    barChartyValue = [NSMutableArray new];
    xVauleLabel = [NSArray new];
    
    formatMonth = [NSDateFormatter new];
    formatYear = [NSDateFormatter new];
    
    // 設定DateFormat
    [formatMonth setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_MONTH
                                                               options:0
                                                                locale:[NSLocale currentLocale]]];
    
    [formatYear setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_YEAR
                                                              options:0
                                                               locale:[NSLocale currentLocale]]];
    
    [self getDataFromCoreDataWithMonth:self.month AndYear:self.year];
    
    
    // PieChart new than add on view
    self.pieChartView = [[PieChartView alloc] init];
    self.pieChartView.backgroundColor = [UIColor clearColor];
    UIColor *color = [UIColor lightGrayColor];
    self.pieChartView.layer.masksToBounds = NO;
    self.pieChartView.layer.shadowColor = [color CGColor];
    self.pieChartView.layer.shadowRadius = 2.0f;
    self.pieChartView.layer.shadowOpacity = 0.67;
    self.pieChartView.layer.shadowOffset = CGSizeMake(8, 8);
    [self.view addSubview:self.pieChartView];
    
    // Scroll View new than add on view
    self.scView = [[UIScrollView alloc] init];
    self.scView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.scView setContentOffset:CGPointMake(0, 0) animated:NO];
    self.scView.delegate = self;
    self.scView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scView];
    
    // BarChart new than add on scroll view
    self.barChartView = [[HorizontalBarChartView alloc] init];
    self.barChartView.backgroundColor = [UIColor clearColor];
    self.barChartView.layer.masksToBounds = NO;
    self.barChartView.layer.shadowColor = [color CGColor];
    self.barChartView.layer.shadowRadius = 2.0f;
    self.barChartView.layer.shadowOpacity = 0.67;
    self.barChartView.layer.shadowOffset = CGSizeMake(8, 8);
    
    [self.scView addSubview:self.barChartView];
    
    [self setPieChartData];
    [self setBarChartData];
    
    [self pieChartSetting];
    [self barChartSetting];
    [self setConstranis];

    
}

- (void) getDataFromCoreDataWithMonth:(NSString *)month AndYear:(NSString *)year {
    
//    NSDate *date = [NSDate date];
//    
//    NSString *currentMonthString = [formatMonth stringFromDate:date];
//    NSString *currentYearString = [formatYear stringFromDate:date];
//    
    
    NSArray *array = [dc getTotalMoneyGroupByCategoryNameWithMonth:month withYear:year];
    [pieChartEntries removeAllObjects];
    [barChartyValue removeAllObjects];
    __block double total = [[array valueForKeyPath:@"@sum.sum"] doubleValue];
    __block double others = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double sum = [[obj valueForKey:@"sum"] doubleValue];
        double percent = sum/total*100;
        NSString *name = [obj valueForKey:@"category.name"];
        
        
        NSLog(@"name: %@, money:%f, total:%f",name,sum,total);
        NSLog(@"precent: %f",sum/total);
        
        if (percent < 3) {
            others += percent;
        } else {
            [pieChartEntries addObject:[[PieChartDataEntry alloc] initWithValue:percent label:name]];
        }
        
        BarChartDataEntry *entry = [[BarChartDataEntry alloc ]initWithX:(double)idx*10 y:sum icon:[UIImage imageNamed:@""]];
        [barChartyValue addObject:entry];
        
        xVauleLabel = [xVauleLabel arrayByAddingObject:name];
        
    }];
    if (others > 0) {
        [pieChartEntries addObject:[[PieChartDataEntry alloc] initWithValue:others label:@"Others" data:@"data"]];
        //        [barChartyValue addObject:[[BarChartDataEntry alloc] initWithX:others y:100.0 data:@"Others"]];
    }
    
    barDataCount = array.count;
    
    
}

#pragma mark - UIScrollViewDelegate 



#pragma mark - Set Char Data

- (void) setBarChartData {
    
    double barWidth = 7.0;
    
    BarChartDataSet *set = nil;
    set = [[BarChartDataSet alloc] initWithValues:barChartyValue label:@"QQ"];
    
    set.drawIconsEnabled = YES;
    set.drawValuesEnabled = YES;
    
    set.colors =[ChartColorTemplates liberty];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    data.barWidth = barWidth;
    
    self.barChartView.data = data;
    
}


- (void) setPieChartData {
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:pieChartEntries];
    
    dataSet.sliceSpace = 2.0;
    
    dataSet.colors = [ChartColorTemplates liberty];
    
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.4;
    dataSet.valueLinePart2Length = 0.5;
    
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.0f;
    pFormatter.percentSymbol = @" %";
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.f]];
    [data setValueTextColor:UIColor.darkGrayColor];
    
    self.pieChartView.data = data;
    
}

#pragma mark - Chart Setting

- (void) pieChartSetting {
    
    self.pieChartView.descriptionText = @"";
    [self.pieChartView setHighlightPerTapEnabled:NO];
    [self.pieChartView setUserInteractionEnabled:NO];
    self.pieChartView.usePercentValuesEnabled = YES;
    self.pieChartView.legend.enabled = NO;
    [self.pieChartView setExtraOffsetsWithLeft:20.f top:0.f right:20.f bottom:0.f];
    
    [self.pieChartView animateWithYAxisDuration:0.6 easingOption:ChartEasingOptionEaseOutSine];
    
}



- (void) barChartSetting {
    
    self.barChartView.delegate = self;
    
    self.barChartView.descriptionText = @"";
    self.barChartView.legend.enabled = NO;
    self.barChartView.drawBarShadowEnabled = NO;
    self.barChartView.drawValueAboveBarEnabled = YES;
    
    self.barChartView.scaleXEnabled = YES;
    //    self.barChartView.dragEnabled = YES;
    
    
    self.barChartView.fitBars = YES;
    self.barChartView.userInteractionEnabled = NO;
    [self.barChartView animateWithYAxisDuration:0.6 easingOption:ChartEasingOptionEaseOutSine];
    self.barChartView.autoScaleMinMaxEnabled = NO;
    
    //    self.barChartView.dragEnabled = YES;
    //    [self.barChartView setScaleEnabled:YES];
    //    self.barChartView.pinchZoomEnabled = YES;
    
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawLabelsEnabled = YES;
    xAxis.granularity = 1.0;
    xAxis.labelFont = [UIFont systemFontOfSize:13.f];
    xAxis.drawAxisLineEnabled = NO;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelCount = barDataCount;
    
    self.barChartView.xAxis.valueFormatter = self;
    
    ChartYAxis *leftAxis = self.barChartView.leftAxis;
    leftAxis.labelTextColor = [UIColor purpleColor];
    leftAxis.enabled = NO;
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = self.barChartView.rightAxis;
    rightAxis.enabled = NO;
    
    
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *_Nullable)axis{
    
    if ((NSInteger)value%10 != 0) {
        return @"";
    } else {
        NSInteger index = value/10;
        return xVauleLabel[index];
    }
    
}


- (void) setConstranis {
    
    
    // PieChart constrains
    self.pieChartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pieChartView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:15].active = YES;
    [self.pieChartView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.pieChartView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    // PieChart'sheight equal ScrollView's height
    [self.pieChartView.heightAnchor constraintEqualToAnchor:self.scView.heightAnchor multiplier:1].active = YES;
    
    // Barchart constrain
    self.barChartView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.barChartView.centerXAnchor constraintEqualToAnchor:self.scView.centerXAnchor].active = YES;
    [self.barChartView.topAnchor constraintEqualToAnchor:self.scView.topAnchor constant:0].active = YES;
    [self.barChartView.bottomAnchor constraintEqualToAnchor:self.scView.bottomAnchor constant:0].active = YES;
    [self.barChartView.leadingAnchor constraintEqualToAnchor:self.scView.leadingAnchor constant:0].active = YES;
    [self.barChartView.trailingAnchor constraintEqualToAnchor:self.scView.trailingAnchor constant:0].active = YES;
    
    [self.barChartView.heightAnchor constraintEqualToConstant:barDataCount*40+30].active = YES;
    [self.barChartView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
    
    
    self.scView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scView.topAnchor constraintEqualToAnchor:self.pieChartView.bottomAnchor constant:0].active = YES;
    [self.scView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [self.scView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [self.scView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:-10].active = YES;
    
    self.scView.contentSize = CGSizeMake(self.view.frame.size.width, self.barChartView.frame.origin.y+self.barChartView.frame.size.height+10);
    
    
    
}


//#pragma mark - GADDelegate
//
//- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
