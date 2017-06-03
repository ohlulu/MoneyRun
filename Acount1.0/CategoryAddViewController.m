//
//  CategoryAddViewController.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/11.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "CategoryAddViewController.h"
#import "DataController.h"
#import "Category+CoreDataClass.h"
#import "Category+CoreDataProperties.h"

@interface CategoryAddViewController () {

    DataController *dc;

}
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation CategoryAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChangeNotification:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    dc = [DataController sharedInstance];
    
    [self.inputField becomeFirstResponder];

    
}
- (IBAction)addButtonPress:(UIButton *)sender {
    if ([self.inputField.text isEqualToString:@""]) {
        return;
    }
    [dc insertCategoryObjectWithCategoryName:self.inputField.text];
    [self.delegate didAddCategory];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)UITextFieldTextDidChangeNotification:(NSNotificationCenter*)notification {
    NSLog(@"123");
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
