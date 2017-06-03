//
//  HistoryViewController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/20.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "HistoryViewController.h"
#import "CustomData.h"
#import "TopCell.h"
#import "NormalCell.h"
#import "AddViewController.h"
#import "OHAcountContin.h"

@interface HistoryViewController () <UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,AddViewControllerDelegate>
{

    DataController *dc;
    NSDate *now;
    NSDate *selectDate;
    NSDateFormatter *formatMonth;
    NSDateFormatter *formatYear;
}


@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray<CustomData *> *datas;
@property (nonatomic) NSMutableDictionary *dictionaryDatas;
@property (weak, nonatomic) IBOutlet UIButton *currentMonthButton;




@end

@implementation HistoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(coreDataHasChange)
                                                     name:COREDATA_HASCHANGE_NOTIFICATION
                                                   object:nil];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ADDBUTTON_NOTIFICATION object:nil];

    
}

//-(id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
//    NSLog(@"catch");
//    return nil;
//}



- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    self.view.tintColor = OHSystemBrownColor;
    
    dc = [DataController sharedInstance];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 52;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    selectDate = [NSDate date];
    
    // 產生一個DateFormat，
    formatMonth = [NSDateFormatter new];
    formatYear = [NSDateFormatter new];
    
    // 設定DateFormat
    [formatMonth setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_MONTH
                                                              options:0
                                                               locale:[NSLocale currentLocale]]];
    
    [formatYear setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_YEAR
                                                               options:0
                                                                locale:[NSLocale currentLocale]]];
    
    // 使用DateFormat 產生一Date字串
    NSString *currentMonthString = [formatMonth stringFromDate:selectDate];
    NSString *currentYearString = [formatYear stringFromDate:selectDate];
    
    [self.currentMonthButton setTitle:currentMonthString forState:UIControlStateNormal];
    
    self.datas = [dc loadItemsGroupByFormatMonth:currentMonthString andFormatYear:currentYearString];
    
    CustomData *topData = [CustomData new];
    topData.title =[NSString localizedStringWithFormat:@"%@",[dc sumOfMoneyWithMonth:currentMonthString andYear:currentYearString]];
    [self.datas insertObject:topData atIndex:0];
    
    // Set view's shadow
    UIColor *color = [UIColor lightGrayColor];
    self.monthView.layer.shadowColor = [color CGColor];
    self.monthView.layer.shadowRadius = 2.0f;
    self.monthView.layer.shadowOpacity = 0.67;
    self.monthView.layer.shadowOffset = CGSizeMake(0, 4);
    self.monthView.layer.masksToBounds = NO;
    
    
    
}

#pragma mark - NSNotitfication 

- (void)coreDataHasChange {
    
    NSString *currentMonthString = [formatMonth stringFromDate:selectDate];
    NSString *currentYearString = [formatYear stringFromDate:selectDate];
    
    self.datas = [dc loadItemsGroupByFormatMonth:currentMonthString andFormatYear:currentYearString];
    
    CustomData *topData = [CustomData new];
    topData.title =[NSString localizedStringWithFormat:@"%@",[dc sumOfMoneyWithMonth:currentMonthString andYear:currentYearString]];
    [self.datas insertObject:topData atIndex:0];
    
    [self.tableView reloadData];
    
}

#pragma mark - Controll Moth Button
- (IBAction)previousMonth:(UIButton *)sender {
    
    [self setSelectMonthButtonTitleWithIncrease:NO];
    
}
- (IBAction)nextMonth:(UIButton *)sender {
    
    [self setSelectMonthButtonTitleWithIncrease:YES];
}

- (void) setSelectMonthButtonTitleWithIncrease:(BOOL) isIncrease {
    
    // Get currentDate's NSTimeInterval form 1970
    NSTimeInterval currentMonth = [selectDate timeIntervalSince1970];
    
    // Get NSCalendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Get how much days in current month
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:selectDate];
    NSLog(@"days %ld",days.length);
    
    if (isIncrease) {
        selectDate = [NSDate dateWithTimeIntervalSince1970:currentMonth+60*60*24*days.length];
    } else {
        selectDate = [NSDate dateWithTimeIntervalSince1970:currentMonth-60*60*24*days.length];
    }
    
    NSString *currentMonthString = [formatMonth stringFromDate:selectDate];
    NSString *currentYearString = [formatYear stringFromDate:selectDate];
    [self.currentMonthButton setTitle:currentMonthString forState:UIControlStateNormal];
    self.datas = [dc loadItemsGroupByFormatMonth:currentMonthString andFormatYear:currentYearString];
    
    CustomData *topData = [CustomData new];
    topData.title =[NSString localizedStringWithFormat:@"%@",[dc sumOfMoneyWithMonth:currentMonthString andYear:currentYearString]];
    [self.datas insertObject:topData atIndex:0];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource

// 總共幾個 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.datas.count;
    
}


// 每一個 section 的 header text
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    } else {
        return self.datas[section].title;
    }
    
}

// 每一個 section 有幾筆資料，預設只有一個section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return self.datas[section].items.count;
    }
    
}

// 每一筆資料長得如何？
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell" forIndexPath:indexPath];
    topCell.totalMoneyByMoth.text = [NSString localizedStringWithFormat:@"$%@",self.datas[indexPath.section].title];
    
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Row with Title
    NSArray *items = self.datas[indexPath.section].items;
    Item *item = items[indexPath.row];
    cell.titleLabel.text = item.category.name;
    
    // Row with money
    NSString * moneyNumber = [NSString localizedStringWithFormat:@"%.0f",[[NSNumber numberWithInt:item.money] floatValue]];
    cell.detailLabel.text = moneyNumber;
    
    // Row with image
    cell.categoryImageView.image = [UIImage imageNamed:item.category.imageName];
    
    // Set FontSize
    [cell.detailLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cell.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    // Set money Color rgba(230.89.25.1) -> rgba(7, 2, 1, 0.3)
    cell.detailLabel.textColor = OHMoneyTextColor;
    
    [cell.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [cell.detailLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    if (indexPath.section == 0) {
        
        return topCell;
        
    } else {
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 34.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34)];
//    view.translatesAutoresizingMaskIntoConstraints = NO;
//    [view.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width].active = YES;
//    [view.heightAnchor constraintEqualToConstant:30].active = YES;

    UILabel *dateLabel = [[UILabel alloc] init];
    UILabel *totalLabel = [[UILabel alloc] init];
    
    [dateLabel setFont:[UIFont systemFontOfSize:18]];
    [totalLabel setFont:[UIFont systemFontOfSize:20]];
    [totalLabel setTextAlignment:NSTextAlignmentRight];
    
    // rgb(216, 61, 22) -> rgb(221, 37, 4)
    totalLabel.textColor = OHHeaderViewTitleColor;
    
    // Total money in Section header
    __block NSInteger total = 0;
    [self.datas[section].items enumerateObjectsUsingBlock:^(Item * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        total += obj.money;
        
    }];
    
//    NSInteger sum = [[self.datas[section].items valueForKeyPath:@"@sum.money"] integerValue];
    
    // Title in Section header
    [dateLabel setText:self.datas[section].title];
    NSString *totalMoney = [NSString localizedStringWithFormat:@"$%.0f",[[NSNumber numberWithInteger:total] floatValue]];
    [totalLabel setText:totalMoney];
    
    // Add Label in view
    [view addSubview:dateLabel];
    [view addSubview:totalLabel];
    
    // Set view's backgroundColor
    view.backgroundColor = OHHeaderViewBackgroundColor;
    
    dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set dateLabel's visualformat
    NSArray *hDateLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[dateLabel(>=100)]" options:0 metrics:0 views:@{@"dateLabel":dateLabel}];
    NSArray *vDateLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[dateLabel(24)]-5-|" options:0 metrics:0 views:@{@"dateLabel":dateLabel}];
    [view addConstraints:hDateLabel];
    [view addConstraints:vDateLabel];
    
    //Set totalLabel's visualformat
    NSArray *hTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"[totalLabel(>=100)]-20-|" options:0 metrics:0 views:@{@"totalLabel":totalLabel}];
    NSArray *vTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[totalLabel(24)]-5-|" options:0 metrics:0 views:@{@"totalLabel":totalLabel}];
    [view addConstraints:hTotalLabel];
    [view addConstraints:vTotalLabel];

    return view;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delect");
//        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Item *item = self.datas[indexPath.section].items[indexPath.row];
        [dc.managedObjectContext deleteObject:item];
        [dc saveToCoreData];
        [self.datas[indexPath.section].items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self coreDataHasChange];
    }
}

-(void)dealloc{
    NSLog(@"HistoryView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:COREDATA_HASCHANGE_NOTIFICATION
                                                  object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"editSegue"]) {
        
        AddViewController *addVC = [segue destinationViewController];
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        addVC.currentItem = self.datas[indexPath.section].items[indexPath.row];
        addVC.delegate = self;
        
    }
}

#pragma mark - AddViewControllerDelegate
-(void)didFinishEditItem:(Item *)item {
    
    NSLog(@"get");
    
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
