//
//  TabBarViewController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/21.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "TabBarViewController.h"
#import "AddViewController.h"
#import "OHMoneyRunContent.h"
@interface TabBarViewController ()
{
    UIButton *addButton;
}

@end

@implementation TabBarViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButton) name:HIDE_ADDBUTTON_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showButton) name:SHOW_ADDBUTTON_NOTIFICATION object:nil];
    
    self.view.tintColor = OHColorRGBA(228, 126, 108, 1);
    addButton = [UIButton buttonWithType:UIButtonTypeSystem];

    [addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
    [self.view addSubview:addButton];
    
    addButton.layer.cornerRadius = 32;
    addButton.layer.shadowColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.87] CGColor];
    addButton.layer.shadowOffset = CGSizeMake(3, 3);
    addButton.layer.shadowOpacity = 2;
    addButton.layer.shadowRadius = 3.0f;
    
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [addButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-4].active = YES;
    [addButton.heightAnchor constraintEqualToConstant:64].active = YES;
    [addButton.widthAnchor constraintEqualToConstant:64].active = YES;
    [addButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    [addButton addTarget:self action:@selector(pushAddView:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

-(IBAction)pushAddView:(UIButton *)sender {
    NSLog(@"pushAddView");
    
    AddViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addViewController"];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:addVC];
    
    [self presentViewController:navi animated:YES completion:^{
        // ...
    }];
    
}

- (void) showButton {
    
    [addButton setHidden:NO];
    
}

- (void) hideButton {
    
    [addButton setHidden:YES];
    
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
