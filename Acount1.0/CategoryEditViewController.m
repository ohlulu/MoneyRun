//
//  EditViewController.m
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/11.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "CategoryEditViewController.h"
#import "DataController.h"
#import "CategoryAddViewController.h"
@interface CategoryEditViewController () <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,CategoryAddViewControllerDelegate>
{
    
    DataController *dc;
    NSMutableArray<Category* > *categoryList;
    NSNotificationCenter *coreDataHasChangeNotification;
    
}
@property (weak, nonatomic) IBOutlet UITableView *categoryEditTableView;

@end

@implementation CategoryEditViewController

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
    
    categoryList = [[dc loadAllCategory] mutableCopy];
    
    [_categoryEditTableView setEditing:YES animated:YES];
    
    [self.navigationController.toolbar setHidden:YES];
    
    
    
}

#pragma mark - UITableViewDataSource
// 每一個 section 有幾筆資料，預設只有一個section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryList.count;
}

// 每一筆資料長得如何？
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [categoryList valueForKey:@"name"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:categoryList[indexPath.row].imageName];
    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor].active = YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    Category *nowCategory = [categoryList objectAtIndex:sourceIndexPath.row];
    [categoryList removeObject:nowCategory];
    [categoryList insertObject:nowCategory atIndex:destinationIndexPath.row];

    if (sourceIndexPath.row != destinationIndexPath.row) {
        
        if (destinationIndexPath.row == categoryList.count-1) {
            
            nowCategory.index = [categoryList objectAtIndex:destinationIndexPath.row-1].index+1;
            
        } else if (destinationIndexPath.row == 0) {
            
            nowCategory.index = [categoryList objectAtIndex:destinationIndexPath.row+1].index-1;
            
        } else {
            
            double previousDestinaCategoryIndex = [categoryList objectAtIndex:destinationIndexPath.row-1].index;
            double nextDestinaCategoryIndex = [categoryList objectAtIndex:destinationIndexPath.row+1].index;
            
            nowCategory.index = (previousDestinaCategoryIndex+nextDestinaCategoryIndex)/2;
            
        }
        
        [dc saveToCoreData];
        
    }
    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
    
}

#pragma mark - UIElement

- (IBAction)addButton:(UIBarButtonItem *)sender {
    
    CategoryAddViewController *addView = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryAddView"];
    addView.modalPresentationStyle = UIModalPresentationPopover;
    addView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    addView.delegate = self;
    
    
    //0 13; 320 480
    addView.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*0.9, 60);
    UIPopoverPresentationController *popPC = addView.popoverPresentationController;
    
//    self.navigationItem.rightBarButtonItem
    popPC.sourceRect = CGRectMake(300, 20, 30, 30);
    popPC.sourceView = self.view;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.delegate = self;
    [self presentViewController:addView animated:YES completion:nil];
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return  UIModalPresentationNone;
}

#pragma mark - CategoryAddViewControllerDelegate

- (void)didAddCategory {
    categoryList = [[dc loadAllCategory] mutableCopy];
    [self.categoryEditTableView reloadData];
}


- (IBAction)saveButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

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
