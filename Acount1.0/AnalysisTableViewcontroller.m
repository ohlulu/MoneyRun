//
//  AnalysisTableViewcontroller.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/6.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AnalysisTableViewcontroller.h"
#import "AnalysisTableViewCell.h"
#import "AnalysisDetailViewController.h"
#import "OHMoneyRunContent.h"
#import "DataController.h"
#import "TabBarViewController.h"
#import "SectionHeaderView.h"

@interface AnalysisTableViewcontroller () <UITableViewDelegate, UITableViewDataSource>
{
    DataController *dc;
    NSMutableArray *datas;
    NSMutableArray *datasPercent;
}

//@property (nonatomic) UIButton *categoryImageBtn;
//@property (nonatomic) UIButton *categoryNameBtn;
//@property (nonatomic) UISegmentedControl *segment;
//@property (nonatomic) UIStackView *stackWithImageAndName;
@property (nonatomic) UITableView *totalTableView;


@end

@implementation AnalysisTableViewcontroller

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_ADDBUTTON_NOTIFICATION object:nil];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.tintColor = OHSystemBrownColor;
    datas = [NSMutableArray new];
    dc = [DataController sharedInstance];
    datas = [dc getTotalMoneyGroupByMonth];
    
    
    /**
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
    */
    
    /**
    // Segment
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"自訂",@"月",@"半年",@"一年"]];
    self.segment.selectedSegmentIndex = 1;
    [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
     */
    
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
    
//    CGFloat elementWidth = [UIScreen mainScreen].bounds.size.width-30;
    
    /**
    
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
    */
    
    /**
    // Segmenet
    self.segment.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segment.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.segment.topAnchor constraintEqualToAnchor:self.categoryNameBtn.bottomAnchor constant:15].active = YES;
    [self.segment.widthAnchor constraintEqualToConstant:elementWidth].active = YES;
    */
    
    // Table View
    self.totalTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.totalTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.totalTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
//    [self.totalTableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.totalTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    [self.totalTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:20].active = YES;
    
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
    
    SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34)];
    view.backgroundColor = [UIColor whiteColor];
    
    
//    UILabel *view.titleLabel = [[UILabel alloc] init];
    [view.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [view.titleLabel setText:[datas[section][0] valueForKey:@"year"]];
    view.titleLabel.textColor = OHSystemBrownAlphaColor;
    
//    UILabel *view.detailLabel = [[UILabel alloc] init];
    [view.detailLabel setFont:[UIFont systemFontOfSize:17]];
    [view.detailLabel setTextAlignment:NSTextAlignmentRight];
    view.detailLabel.text = [NSString localizedStringWithFormat:@"$%0ld",[[datas[section] valueForKeyPath:@"@sum.money"] integerValue]];
    view.detailLabel.numberOfLines = 0;
    [view.detailLabel sizeToFit];
    view.detailLabel.textColor = OHHeaderViewTitleColor;
    
    [view addSubview:view.titleLabel];
    [view addSubview:view.detailLabel];
    
    view.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    view.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set dateLabel's visualformat
    NSArray *hYearLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"|-45-[yearLabel(>=80)]" options:0 metrics:0 views:@{@"yearLabel":view.titleLabel}];
    NSArray *vYearLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[yearLabel(24)]-5-|" options:0 metrics:0 views:@{@"yearLabel":view.titleLabel}];
    [view addConstraints:hYearLabel];
    [view addConstraints:vYearLabel];
    
    //Set totalLabel's visualformat
    NSArray *hTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"[totalLabel]-15-|" options:0 metrics:0 views:@{@"totalLabel":view.detailLabel}];
    NSArray *vTotalLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[totalLabel(24)]-5-|" options:0 metrics:0 views:@{@"totalLabel":view.detailLabel}];
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
    cell.rectangleWidth = [[datas[indexPath.section][indexPath.row] valueForKey:@"percentWithYear"] floatValue];
    cell.monthLabel.text = [datas[indexPath.section][indexPath.row] valueForKey:@"month"];
    cell.moneyLabel.text = [NSString localizedStringWithFormat:@"%0.f",[[datas[indexPath.section][indexPath.row] valueForKey:@"money"] floatValue]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *year = [datas[indexPath.section][0] valueForKey:@"year"];
    NSString *month = [datas[indexPath.section][indexPath.row] valueForKey:@"month"];

    AnalysisDetailViewController *analysisVC = [AnalysisDetailViewController new];
    analysisVC.year = year;
    analysisVC.month = month;
    
    [self.navigationController pushViewController:analysisVC animated:YES];
    
}


- (void) categoryButtonClick:(UIButton *)sender {
    NSLog(@"1");
}

- (void) segmentValueChange:(UISegmentedControl *)sender {
    NSLog(@"2");
}

- (void) showAlert {
    
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
