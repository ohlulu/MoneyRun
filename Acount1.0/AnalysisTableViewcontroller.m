//
//  AnalysisTableViewcontroller.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/6.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisTableViewcontroller.h"
#import "AnalysisTableViewCell.h"
#import "AnalysisViewController.m"
#import "OHMoneyRunContent.h"
#import "DataController.h"

@interface AnalysisTableViewcontroller () <UITableViewDelegate, UITableViewDataSource>
{
    DataController *dc;
    NSMutableArray *datas;
}

@property (nonatomic) UIButton *categoryImageBtn;
@property (nonatomic) UIButton *categoryNameBtn;
@property (nonatomic) UISegmentedControl *segment;
@property (nonatomic) UIStackView *stackWithImageAndName;
@property (nonatomic) UITableView *totalTableView;


@end

@implementation AnalysisTableViewcontroller

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.tintColor = OHSystemBrownColor;
    datas = [NSMutableArray new];
    dc = [DataController sharedInstance];
    datas = [dc getTotalMoneyGroupByMonth];
    
    // Image Button
    self.categoryImageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.categoryImageBtn setBackgroundImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
    [self.categoryImageBtn addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // Name Button
    self.categoryNameBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.categoryNameBtn setTitle:@"All category" forState:UIControlStateNormal];
    [self.categoryNameBtn addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.categoryNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.categoryNameBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    // Stack View
    self.stackWithImageAndName = [[UIStackView alloc] initWithArrangedSubviews:@[self.categoryImageBtn,self.categoryNameBtn]];
    self.stackWithImageAndName.axis = UILayoutConstraintAxisHorizontal;
    self.stackWithImageAndName.distribution = UIStackViewDistributionFill;
    self.stackWithImageAndName.alignment = UIStackViewAlignmentCenter;
    self.stackWithImageAndName.spacing = 15;
    [self.view addSubview:self.stackWithImageAndName];
    
    // Segment
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"自訂",@"月",@"半年",@"一年"]];
    self.segment.selectedSegmentIndex = 1;
    [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    // TableView
    self.totalTableView = [[UITableView alloc] init];
    self.totalTableView.delegate = self;
    self.totalTableView.dataSource = self;
    self.totalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.totalTableView];
    
    
    [self setConstrains];
}

#pragma mark - SetConstrains

- (void) setConstrains {
    
    CGFloat elementWidth = [UIScreen mainScreen].bounds.size.width-30;
    
    // Stack View
    self.stackWithImageAndName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackWithImageAndName.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    [self.stackWithImageAndName.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.stackWithImageAndName.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:10].active = YES;
    [self.stackWithImageAndName.heightAnchor constraintEqualToConstant:46].active = YES;
    
    // Category Btuuon
    self.categoryNameBtn.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryImageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(40)]" options:0 metrics:0 views:@{@"image":self.categoryImageBtn}];
    NSArray *vImageBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[image(40)]" options:0 metrics:0 views:@{@"image":self.categoryImageBtn}];
    NSArray *vNameBtn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[text(40)]" options:0 metrics:0 views:@{@"text":self.categoryNameBtn}];
    [self.stackWithImageAndName addConstraints:hBtn];
    [self.stackWithImageAndName addConstraints:vImageBtn];
    [self.stackWithImageAndName addConstraints:vNameBtn];
    
    // Segmenet
    self.segment.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segment.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.segment.topAnchor constraintEqualToAnchor:self.categoryNameBtn.bottomAnchor constant:15].active = YES;
    [self.segment.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    
    // Table View
    self.totalTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.totalTableView.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    [self.totalTableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.totalTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:8].active = YES;
    [self.totalTableView.topAnchor constraintEqualToAnchor:self.segment.bottomAnchor constant:8].active = YES;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datas.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [datas[section][0] valueForKey:@"year"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34)];
    
    
    UILabel *yearLabel = [[UILabel alloc] init];
    [yearLabel setFont:[UIFont systemFontOfSize:15]];
    [yearLabel setText:[datas[section][0] valueForKey:@"year"]];
    yearLabel.textColor = OHCalendarGrayColor;
    
    UILabel *totalLabel = [[UILabel alloc] init];
    [totalLabel setFont:[UIFont systemFontOfSize:17]];
    [totalLabel setTextAlignment:NSTextAlignmentRight];
    totalLabel.text = [NSString localizedStringWithFormat:@"%0.f",[[datas[section] valueForKeyPath:@"@sum.money"] floatValue]];
    totalLabel.textColor = OHHeaderViewTitleColor;
    
    [view addSubview:yearLabel];
    [view addSubview:totalLabel];
    
    yearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set dateLabel's visualformat
    NSArray *hYearLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[yearLabel(>=100)]" options:0 metrics:0 views:@{@"yearLabel":yearLabel}];
    NSArray *vYearLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[yearLabel(24)]-5-|" options:0 metrics:0 views:@{@"yearLabel":yearLabel}];
    [view addConstraints:hYearLabel];
    [view addConstraints:vYearLabel];
    
    //Set totalLabel's visualformat
    NSArray *hTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"[totalLabel(>=100)]-8-|" options:0 metrics:0 views:@{@"totalLabel":totalLabel}];
    NSArray *vTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[totalLabel(24)]-5-|" options:0 metrics:0 views:@{@"totalLabel":totalLabel}];
    [view addConstraints:hTotalLabel];
    [view addConstraints:vTotalLabel];
    
    return view;
}

// 每一個 section 有幾筆資料，預設只有一個section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[datas[section] valueForKeyPath:@"@count"] integerValue];
}

// 每一筆資料長得如何？
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView registerClass:[AnalysisTableViewCell class] forCellReuseIdentifier:@"cell"];
    AnalysisTableViewCell *cell = (AnalysisTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.monthLabel.text = [datas[indexPath.section][indexPath.row] valueForKey:@"month"];
    cell.moneyLabel.text = [NSString localizedStringWithFormat:@"%0.f",[[datas[indexPath.section][indexPath.row] valueForKey:@"money"] floatValue]];

    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AnalysisViewController *analysisVC = [self.storyboard instantiateViewControllerWithIdentifier:@"detailAnalysis"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:analysisVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void) categoryButtonClick:(UIButton *)sender {
    NSLog(@"1");
}

- (void) segmentValueChange:(UISegmentedControl *)sender {
    NSLog(@"2");
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
