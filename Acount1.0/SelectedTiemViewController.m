//
//  SelectedTiemViewController.m
//  Where money run
//
//  Created by Ohlulu on 2017/6/14.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SelectedTiemViewController.h"
#import "OHMoneyRunContent.h"
@interface SelectedTiemViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cencalButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *nowTimeButton;

@end

@implementation SelectedTiemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.superview.backgroundColor = [UIColor clearColor];
    
    UIColor *color = OHCalendarGrayAlphColor;
    CGColorRef cgColor = color.CGColor;;
    
    CGFloat borderWidth = 1.0f;
    
    self.cencalButton.layer.borderColor = cgColor;
    self.cencalButton.layer.borderWidth = borderWidth;
    self.doneButton.layer.borderColor = cgColor;
    self.doneButton.layer.borderWidth = borderWidth;
    self.timePicker.layer.borderColor = cgColor;
    self.timePicker.layer.borderWidth = borderWidth;
    self.nowTimeButton.layer.borderColor = cgColor;
    self.nowTimeButton.layer.borderWidth = borderWidth;
    self.bgView.layer.borderWidth = 2.0f;
    self.bgView.layer.borderColor = cgColor;
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:notityTime];
    [self.timePicker setDate:date];

    
}

#pragma mark - UIElement

- (IBAction)cencelButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonClick:(id)sender {
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeStyle:NSDateFormatterLongStyle];
    
    [self.delegate didSelectedTime:self.timePicker.date];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nowTimeButtonClick:(id)sender {
    NSDate *date = [NSDate date];
    [self.timePicker setDate:date];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
