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
#import "SubtitleCell.h"
#import "AddViewController.h"
#import "OHMoneyRunContent.h"
#import "SettingTableViewContoller.h"
@import StoreKit;

@interface HistoryViewController () <UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,AddViewControllerDelegate,UIAlertViewDelegate,SKStoreProductViewControllerDelegate>
{

    DataController *dc;
    NSDate *now;
    NSDate *selectDate;
    NSDateFormatter *formatMonth;
    NSDateFormatter *formatYear;
    NSCalendar *calendar;
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
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ADDBUTTON_NOTIFICATION object:nil];

    
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    
    self.view.tintColor = OHSystemBrownColor;
    self.view.backgroundColor = OHCalendarWhiteColor;
    calendar = [NSCalendar currentCalendar];
    
    dc = [DataController sharedInstance];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 52;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor clearColor];
    
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
    self.monthView.backgroundColor = OHCalendarWhiteColor;
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
    
    [self showAskViewController];
    
}

#pragma mark - Show Ask View Controller

- (void) showAskViewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger count = [defaults integerForKey:addBtnPressCount];
    if (count < 3) {
        count++;
        [defaults setInteger:count forKey:addBtnPressCount];
    } else {
        bool isShowSR = [defaults boolForKey:isShowStoreReview];
        if (!isShowSR) {
            if (NSClassFromString(@"SKStoreReviewController")) {
                [SKStoreReviewController requestReview];
                [defaults setBool:YES forKey:isShowStoreReview];
            } else {
                UIAlertController *askController = [UIAlertController alertControllerWithTitle:@"Hello" message:@"If you like this app, please rate in App store. Thanks." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *okActino = [UIAlertAction actionWithTitle:@"Rate" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *appID = @"1242869090";
                    NSString *rateURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURL] options:@{} completionHandler:nil];
                    [defaults setBool:YES forKey:isShowStoreReview];
                }];
                [askController addAction:laterAction];
                [askController addAction:okActino];
                [self presentViewController:askController animated:YES completion:nil];
                
            }
            
        }
    }
    
}

#pragma mark - Controll Moth Button

- (IBAction)monthButtonClick:(UIButton *)sender {
    
    NSDate *date = [NSDate date];
    [self goToMonthWithDate:date];
    
}


- (IBAction)previousMonth:(UIButton *)sender {
    
    [self setSelectMonthButtonTitleWithIncrease:NO];
    
}
- (IBAction)nextMonth:(UIButton *)sender {
    
    [self setSelectMonthButtonTitleWithIncrease:YES];
}

- (void) setSelectMonthButtonTitleWithIncrease:(BOOL) isIncrease {
    
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components = [calendar components:unit fromDate:selectDate];
    
    if (isIncrease) {
        components.month++;
        selectDate = [calendar dateFromComponents:components];
    } else {
        components.month--;
        selectDate = [calendar dateFromComponents:components];
    }
    
    [self goToMonthWithDate:selectDate];
    
}

- (void) goToMonthWithDate:(NSDate *) date {
    
    NSString *currentMonthString = [formatMonth stringFromDate:date];
    NSString *currentYearString = [formatYear stringFromDate:date];
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
//    topCell.backgroundColor = [UIColor clearColor];
    
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    SubtitleCell *subTitleCell = [tableView dequeueReusableCellWithIdentifier:@"subTitleCell" forIndexPath:indexPath];
    subTitleCell.backgroundColor = [UIColor clearColor];
    
    // Row with Title
    NSArray *items = self.datas[indexPath.section].items;
    Item *item = items[indexPath.row];
    
    // Cell's money
    NSString * moneyNumber = [NSString localizedStringWithFormat:@"%.0f",[[NSNumber numberWithInt:item.money] floatValue]];
    
    // Set Font
    [cell.detailLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cell.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [subTitleCell.detailLabel setFont:[UIFont systemFontOfSize:15.0]];
    [subTitleCell.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
//    cell.titleLabel.textColor = OHCalendarGrayColor;
    subTitleCell.subTitleLabel.textColor = OHCalendarGrayColor;

    
    // Set money Color rgba(230.89.25.1) -> rgba(7, 2, 1, 0.3)
    cell.detailLabel.textColor = OHMoneyTextColor;
//    [cell.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [cell.detailLabel setFont:[UIFont systemFontOfSize:18]];
    
    subTitleCell.detailLabel.textColor = OHMoneyTextColor;
//    [cell.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [cell.detailLabel setFont:[UIFont systemFontOfSize:18]];
    
    if (item.remark.length != 0 || item.remark != nil) {
        
        // Cell's image
        subTitleCell.categoryImageView.image = [UIImage imageNamed:item.category.imageName];
        
        
        // Cell's Category name
        subTitleCell.titleLabel.text = item.category.name;
        
        // Cell's remark
        subTitleCell.subTitleLabel.text = [NSString stringWithFormat:@"# %@",item.remark];
        
        // Cell's money
        subTitleCell.detailLabel.text = moneyNumber;
        
    } else {
        
        // Cell's image
        cell.categoryImageView.image = [UIImage imageNamed:item.category.imageName];
        
        // Cell's Category name
        cell.titleLabel.text = item.category.name;
        
        // Cell's money
        cell.detailLabel.text = moneyNumber;

    }
       
    if (indexPath.section == 0) {
        
        return topCell;
        
    } else {
        if (item.remark != nil) {
            return subTitleCell;
        } else {
            return cell;
        }
        
        
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
    
    UILabel *dateLabel = [[UILabel alloc] init];
    UILabel *totalLabel = [[UILabel alloc] init];
    
    [dateLabel setFont:[UIFont systemFontOfSize:16]];
    [totalLabel setFont:[UIFont systemFontOfSize:18]];
    [totalLabel setTextAlignment:NSTextAlignmentRight];
    dateLabel.textColor = OHHeaderViewDateTextColor;
    totalLabel.textColor = OHHeaderViewMoneyTextColor;
    
    // Total money in Section header
    __block NSInteger total = 0;
    [self.datas[section].items enumerateObjectsUsingBlock:^(Item * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        total += obj.money;
    }];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delect");
        Item *item = self.datas[indexPath.section].items[indexPath.row];
        [dc.managedObjectContext deleteObject:item];
        [dc saveToCoreData];
        [self.datas[indexPath.section].items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self coreDataHasChange];
        [[NSNotificationCenter defaultCenter] postNotificationName:COREDATA_HASCHANGE_NOTIFICATION object:nil];
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

- (IBAction)settingButtonClick:(UIButton *)sender {
    
    SettingTableViewContoller *setVC = [self.storyboard instantiateViewControllerWithIdentifier:@"settingTableView"];
    
    [self.navigationController pushViewController:setVC animated:YES];
    
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
