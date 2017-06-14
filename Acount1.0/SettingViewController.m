//
//  SettingViewController.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/6/13.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SettingViewController.h"
#import "OHMoneyRunContent.h"
#import "SettingTableViewCell.h"
#import "CategoryEditViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *settingList;
}
@property (nonatomic) UITableView *settingTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = OHCalendarWhiteColor;
    self.view.tintColor = OHSystemBrownColor;
    
    // Navigation
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = OHCalendarWhiteColor;
    self.navigationController.navigationBar.tintColor = OHSystemBrownColor;
    
    // Navigation Itme
    UIBarButtonItem * okButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ok"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClivk)];
    self.navigationItem.rightBarButtonItem = okButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    // TabBar Hidden
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_ADDBUTTON_NOTIFICATION object:nil];
    
    // TableView
    self.settingTableView = [UITableView new];
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.settingTableView];
    
    [self setAutoLayout];
    [self getList];
    
}

- (void) getList {
    settingList = [NSMutableArray new];
    [settingList addObject:@"Category"];
    [settingList addObject:@"Notification"];
}

- (void) setAutoLayout {
    
    self.settingTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.settingTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:8].active = YES;
    [self.settingTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:8].active = YES;
    [self.settingTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-8].active = YES;
    [self.settingTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor constant:-8].active = YES;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settingList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = settingList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.layer.cornerRadius = 5.0f;
    
    return cell;
    
}

#pragma mark - UITableViewdelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        CategoryEditViewController *editViiew = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryEditViiew"];
        
        [self showViewController:editViiew sender:self];
        
    }
  
    
}

#pragma mark - UIelement 

- (void) doneButtonClivk {

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
