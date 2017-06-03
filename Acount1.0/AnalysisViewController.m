//
//  AnalysisViewController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/20.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisViewController.h"
#import "AddViewController.h"
#import "DataController.h"
#import "OHMoneyRunContent.h"
@import Charts;



@interface AnalysisViewController ()<ChartViewDelegate,IChartAxisValueFormatter>
{

    __block NSMutableArray *pieChartEntries;
    __block NSMutableArray *barChartyValue;
    DataController *dc;
    __block NSArray<NSString *> *xVauleLabel;
    NSInteger barDataCount;
    NSDateFormatter *formatMonth;
    NSDateFormatter *formatYear;
    
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *dateRangSegment;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;
@property (nonatomic) HorizontalBarChartView *barChartView;
@property (nonatomic) UIScrollView *scView;

@end

@implementation AnalysisViewController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    self.scView = [[UIScrollView alloc] init];
//    self.scView.backgroundColor = UIColor.lightGrayColor;
    self.scView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 800);
    self.scView.pagingEnabled = YES;
    [self.view addSubview:self.scView];
    
    self.barChartView = [[HorizontalBarChartView alloc] init];
    
    
    [self.scView addSubview:self.barChartView];
    
    self.dateRangSegment.tintColor = OHSystemBrownColor;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
//    [UIView animateWithDuration:0.5 animations:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_ADDBUTTON_NOTIFICATION object:nil];
//        [self.tabBarController.tabBar setHidden:YES];
//    }];
    self.tabBarController.tabBar.hidden = NO;
    
    [self getDataFromCoreDataWithRange:0];
    [self setPieChartData];
    [self setBarChartData];
    
    [self pieChartSetting];
    [self barChartSetting];
    [self setConstranis];
    
    
}

- (void) getDataFromCoreDataWithRange:(NSInteger) index {
    
    NSDate *date = [NSDate date];
    
    NSString *currentMonthString = [formatMonth stringFromDate:date];
    NSString *currentYearString = [formatYear stringFromDate:date];
    
    
    NSArray *array = [dc getTotalMoneyGroupByCategoryNameWithDateRang:currentMonthString withFormatYear:currentYearString segment:index];
    [pieChartEntries removeAllObjects];
    [barChartyValue removeAllObjects];
    __block NSInteger total = [[array valueForKeyPath:@"@sum.sum"] integerValue];
    __block double others = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        double percent = [[obj valueForKey:@"sum"] doubleValue]/total*100;
        NSString *name = [obj valueForKey:@"category.name"];
        double sum = [[obj valueForKey:@"sum"] doubleValue];
        
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

#pragma mark - Set Char Data

- (void) setBarChartData {
    
    double barWidth = 7.0;
    
    BarChartDataSet *set = nil;
    set = [[BarChartDataSet alloc] initWithValues:barChartyValue label:@"1234"];
    
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
    pFormatter.multiplier = @1.1f;
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

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    
    if ((NSInteger)value%10 != 0) {
        return @"";
    } else {
        NSInteger index = value/10;
        return xVauleLabel[index];
    }
    
}


- (void) setConstranis {
    
    self.dateRangSegment.translatesAutoresizingMaskIntoConstraints = NO;
    self.pieChartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.dateRangSegment.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:8].active = YES;
    [self.dateRangSegment.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10].active = YES;
    [self.dateRangSegment.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10].active = YES;
    
    [self.pieChartView.topAnchor constraintEqualToAnchor:self.dateRangSegment.bottomAnchor constant:10].active = YES;
    [self.pieChartView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.pieChartView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.pieChartView.heightAnchor constraintEqualToAnchor:self.scView.heightAnchor multiplier:1].active = YES;
    
    self.scView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scView.topAnchor constraintEqualToAnchor:self.pieChartView.bottomAnchor constant:10].active = YES;
    [self.scView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [self.scView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [self.scView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:-10].active = YES;
    
    self.barChartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.barChartView.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.active = NO;
    }];
    
    [self.barChartView.centerXAnchor constraintEqualToAnchor:self.scView.centerXAnchor].active = YES;
    [self.barChartView.topAnchor constraintEqualToAnchor:self.scView.topAnchor constant:30].active = YES;
    [self.barChartView.heightAnchor constraintEqualToConstant:barDataCount*30+50].active = YES;
    [self.barChartView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
    [self.barChartView.bottomAnchor constraintEqualToAnchor:self.scView.bottomAnchor constant:-20].active = YES;
    
}
- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    NSLog(@"index %ld",sender.selectedSegmentIndex);
    
    self.barChartView.data = nil;
    
    [self getDataFromCoreDataWithRange:sender.selectedSegmentIndex];
    [self setPieChartData];
    [self setBarChartData];
    
    [self pieChartSetting];
    [self barChartSetting];
    
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
