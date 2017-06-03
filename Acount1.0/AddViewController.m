//
//  AddViewController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/20.
//  Copyright © 2017年 ohlulu. All rights reserved.
//
#import "OHAcountContin.h"
#import "AddViewController.h"
#import "DataController.h"
#import "Category+CoreDataClass.h"
#import "Category+CoreDataProperties.h"
#import <FSCalendar/FSCalendar.h>
#import "CalendarViewController.h"

@interface AddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FSCalendarDelegate,FSCalendarDataSource,CalendarViewControllerDelegate>
{
    
    NSDate *prepareTrueDate;
    NSString *prepareFormatDate;
    DataController *dc;
    NSSet *list;
    UIView *calendarView;
    NSDateFormatter *dateFormat;
    __block NSInteger selectIndex;
    NSString *selectedCategoryName;
    NSNumberFormatter *currencyFormatter;
    
}

@property (strong, nonatomic) NSMutableArray<Category *> *categoryList;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITableView *categoryTable;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSegment;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *addGreenView;
@property (weak, nonatomic) IBOutlet UIView *whiteBoard;

@end

@implementation AddViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.moneyText resignFirstResponder];
    [self.tabBarController.tabBar setHidden:YES];
    
    // Get all category
    dc = [DataController sharedInstance];
    self.categoryList = [[dc loadAllCategory] mutableCopy];
    [self.categoryTable reloadData];
    
    if (self.presentingViewController) {
        
        // Init addButton status and background color
        [self.addButton setEnabled:NO];
        self.addButton.backgroundColor = [UIColor lightGrayColor];
        
        NSString *imageName = self.categoryList[0].imageName;
        self.categoryImageView.image = [UIImage imageNamed:imageName];
        selectedCategoryName = self.categoryList[0].name;
        
    } else {
        
        [self.addButton setEnabled:YES];
        self.addButton.backgroundColor = OHSaveButtonActionColor;
        
        selectedCategoryName = self.currentItem.category.name;
        [self.categoryList enumerateObjectsUsingBlock:^(Category * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.imageName isEqualToString:self.currentItem.category.imageName]) {
                selectIndex = idx;
            }
        }];
    }
    
    [self.navigationController.navigationBar setHidden:NO];
    
    if (self.presentingViewController) {
        
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_ADDBUTTON_NOTIFICATION object:nil];
    }

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.moneyText becomeFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.locale = [NSLocale currentLocale];
    currencyFormatter.maximumFractionDigits = 0;
    currencyFormatter.maximumIntegerDigits = 8;
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    if (self.presentingViewController) {
        [self.navigationItem.leftBarButtonItem setTitle:@"Cancel"];
    }
    
    
    CGSize naviSize = self.navigationController.navigationBar.frame.size;
    
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, naviSize.width, naviSize.height);
    
    // Clear color with cursor
    self.moneyText.tintColor = [UIColor clearColor];
    self.moneyText.backgroundColor = OHSystemBrownColor;
    self.moneyText.textColor = [UIColor whiteColor];
    
    // Init date format
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterLongStyle];
    [dateFormat setTimeStyle:NSDateFormatterNoStyle];
    
    if (self.presentingViewController) {
        
        // If addVC's pressentingVC is tabBarController
        // Get current date and set title button with current date
        NSDate *currentDate = [NSDate date];
        prepareTrueDate = currentDate;
        [self setDateButtonTitleWithDate:currentDate];
        
        // Clean moneyLabel's text
        self.moneyText.text = [currencyFormatter stringFromNumber:@(0)];
        
    } else {
        // If addVC is push from historyVC's cell
        // Init data from HistoryView
        NSString *localeString = [currencyFormatter stringFromNumber:[NSNumber numberWithInt:self.currentItem.money]];
        self.moneyText.text = localeString;
        self.categoryImageView.image = [UIImage imageNamed:self.currentItem.category.imageName];
        
        prepareFormatDate = self.currentItem.formatDate;
        prepareTrueDate = self.currentItem.trueDate;
        
        [self.dateButton setTitle:prepareFormatDate forState:UIControlStateNormal];
        
    }
    
    // Remove navigationbar's border
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIColor *color = OHSystemBrownColor;

    self.navigationController.navigationBar.backgroundColor = color;
    self.addGreenView.backgroundColor = color;
    self.dateButton.tintColor = color;
    self.dateSegment.tintColor = color;
    
    // Set table's dataSource and delegate
    self.categoryTable.delegate = self;
    self.categoryTable.dataSource = self;
    
    // Set label's delegate
    self.moneyText.delegate = self;
    
    [self.categoryTable.bottomAnchor constraintEqualToAnchor:self.addButton.topAnchor constant:-20].active = YES;
    
    self.whiteBoard.layer.cornerRadius = 21.0;

}


- (void) setDateButtonTitleWithDate:(NSDate *) date {
    NSString *currentDateString = [dateFormat stringFromDate:date];
    [self.dateButton setTitle:currentDateString forState:UIControlStateNormal];
}

#pragma mark - UITableViewDataSource

//section[0]有幾筆資料，預設只有一個section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoryList.count;

}

//每一筆資料長得如何？
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self.categoryList valueForKey:@"name"][indexPath.row];
    
    cell.imageView.image =[UIImage imageNamed:[self.categoryList valueForKey:@"imageName"][indexPath.row]];
    
    if (selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectIndex = indexPath.row;
    selectedCategoryName = [self.categoryTable cellForRowAtIndexPath:indexPath].textLabel.text;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //background
        [NSThread sleepForTimeInterval:0.3];
        dispatch_async(dispatch_get_main_queue(), ^{
            //thread 1
            [self.categoryTable reloadData];
        });
    });
    
    [self.categoryTable deselectRowAtIndexPath:indexPath animated:YES];
//    [self.categoryName setText:[self.categoryList valueForKey:@"name"][indexPath.row]];
    NSString *selectedImageName = [self.categoryList[indexPath.row] valueForKey:@"imageName"];
    self.categoryImageView.image = [UIImage imageNamed:selectedImageName];
 
}


#pragma mark - UIelement

- (IBAction)cancel:(id)sender {
    
    [self.moneyText resignFirstResponder];
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)saveBtnPress:(id)sender {
    
    NSMutableString *intString = [self.moneyText.text mutableCopy];
    [intString deleteCharactersInRange:NSMakeRange(0, 1)];
    [intString replaceOccurrencesOfString:@"," withString:@"" options:NSLiteralSearch range:NSMakeRange(0, intString.length)];
    
    if ([intString integerValue] == 0) {
        
        return;
    }
    
    if ([selectedCategoryName isEqualToString:@""]) {
        return;
    }
    
    [self.moneyText resignFirstResponder];
    
    prepareFormatDate = [dateFormat stringFromDate:prepareTrueDate];
    
    
    if (self.presentingViewController) {
        
        // If addVC is pressenting from tabBarController
        
        // New managed object then insert to core data
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_ITEM inManagedObjectContext:dc.managedObjectContext];
        
        item.index = [[NSUUID UUID] UUIDString];
        item.money = [intString intValue];
        item.trueDate = prepareTrueDate;
        item.formatDate = prepareFormatDate;
        item.io = NO;
        
        [dc insertItem:item WithCategorylName:selectedCategoryName];
        
        // Dismiss addVC
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        // If addVC is show from historyVC's cell
        
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_ITEM inManagedObjectContext:dc.managedObjectContext];
        
        item.index = [[NSUUID UUID] UUIDString];
        item.money = [intString intValue];
        item.trueDate = prepareTrueDate;
        item.formatDate = prepareFormatDate;
        item.io = NO;
        
        [dc insertItem:item WithCategorylName:selectedCategoryName];
        
//        [self.currentItem.category removeItemsObject:self.currentItem];
//        [self.currentItem.category removeItems:[NSSet setWithObject:self.currentItem]];
//        [dc deleteItem:self.currentItem WithCategorylName:self.currentItem.category.name];
        [dc.managedObjectContext deleteObject:self.currentItem];
        
//        self.currentItem.money = [intString intValue];
//        self.currentItem.trueDate = prepareTrueDate;
//        self.currentItem.formatDate = prepareFormatDate;
//        self.currentItem.category.imageName = ;
//        self.currentItem.category.name = selectedCategoryName;
//        [dc saveToCoreData];
        
//        [self.delegate didFinishEditItem:self.currentItem];
        [self.navigationController popViewControllerAnimated:YES];
    
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:COREDATA_HASCHANGE_NOTIFICATION object:nil userInfo:nil];
    
    
    
}

- (IBAction)selectDataWIthFSCalendar:(UIButton *)sender {

    
    CalendarViewController *pic = [[CalendarViewController alloc] init];
    
    pic.modalPresentationStyle = UIModalPresentationCustom;
    pic.delegate = self;
    pic.today = prepareTrueDate;

    [self presentViewController:pic animated:YES completion:^{
        
        pic.view.superview.backgroundColor = [UIColor clearColor];
        
    }];
    
    [self.view endEditing:YES];
    
    
}

- (IBAction)segmentValueChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            prepareTrueDate = [NSDate date];
            [self setDateButtonTitleWithDate:[NSDate date]];
        }
            break;
        case 1:
        {
            double yesterday = [[NSDate date] timeIntervalSince1970]-60*60*24;
            prepareTrueDate = [NSDate dateWithTimeIntervalSince1970:yesterday];
            [self setDateButtonTitleWithDate:[NSDate dateWithTimeIntervalSince1970:yesterday]];
        }
            
            break;
        default:
            return;
            break;
    }
    
}

#pragma mark - CalendarViewControllerDelegate
-(void)calendarViewController:(UIViewController *)view didSelectDate:(NSDate *)date{
    
    prepareTrueDate = date;
    prepareFormatDate = [dateFormat stringFromDate:date];
    
    self.dateSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    [self setDateButtonTitleWithDate:date];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [calendarView setHidden:YES];
    
}

#pragma mark - UITextFieldTextDidChangeNotification

- (void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    
    NSMutableString *intString = [self.moneyText.text mutableCopy];
    [intString deleteCharactersInRange:NSMakeRange(0, 1)];
    [intString replaceOccurrencesOfString:@"," withString:@"" options:NSLiteralSearch range:NSMakeRange(0, intString.length)];
    
    if ([intString integerValue] > 0) {
        [self.addButton setEnabled:YES];
        // rgba(58, 180, 58, 0.84)
        [UIView animateWithDuration:0.5 animations:^{
            self.addButton.backgroundColor = OHSaveButtonActionColor;
        }];
        
    } else if ([intString intValue] == 0 ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.addButton.backgroundColor = [UIColor lightGrayColor];
        }];
    }
    
    
    
    NSString *localeString = [currencyFormatter stringFromNumber:[NSNumber numberWithInteger:[intString integerValue]]];
    self.moneyText.text = localeString;
    

    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    
}



#pragma mark - UIKeyboardDidShowNotification

- (void)keyboardWillShowNotification:(NSNotification*)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    [UIView animateWithDuration:0.25 animations:^{
        [self.addButtonBottomConstraint setConstant:keyboardFrameBeginRect.size.height];
        [self.view layoutIfNeeded];
    }];
    
}

- (void) keyboardWillHideNotification:(NSNotification *) notification {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.addButtonBottomConstraint setConstant:0];
        [self.view layoutIfNeeded];
    }];
    
}


- (void) setMoneyTextFieldWithlocalizedString:(NSString *) string {
    
    self.moneyText.text = [NSString localizedStringWithFormat:@"%@",string];
    
    
    
}


- (IBAction)AddCategoryName:(id)sender {
    
    

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