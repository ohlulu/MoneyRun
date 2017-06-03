//
//  ViewController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/11.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UISwitch *getORpay;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;

@end

@implementation ViewController

-(NSManagedObjectContext *)connectCoreData{
    
    NSPersistentContainer *pc = [[NSPersistentContainer alloc] initWithName:@"Acount1_0"];
    [pc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull desc, NSError * _Nullable err) {
        if (err != nil) {
            NSLog(@"connect err: %@",err);
        } else {
            NSLog(@"connect OK! %@",desc);
        }
    }];
    return pc.viewContext;
}

-(void)insertData:(NSManagedObjectContext *)mbc {
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:mbc];
    NSManagedObject *item = [[NSManagedObject alloc] initWithEntity:desc insertIntoManagedObjectContext: mbc];
//    NSLog(@"item: %@",item);
    NSDate *date = [[NSDate alloc] init];
//    NSLog(@"date: %@",date);
    [item setValue:@(1) forKey:@"sid"];
    [item setValue:@(100) forKey:@"money"];
    [item setValue:@(NO) forKey:@"get_pay"];
    [item setValue:date forKey:@"date"];
    [item setValue:@(1) forKey:@"categories_sid"];
    

    [mbc save:nil];
}

-(void)printData:(NSManagedObjectContext *)mbc {
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName: @"Items"];
    
    NSError * err;
    NSArray * arr = [mbc executeFetchRequest:request error:&err];
    if (err != nil) {
        NSLog(@"print err: %@", err);
    } else {
        NSManagedObject *eb;
        
        for(int k=0; k < arr.count ; k += 1) {
            eb = arr[k];
            NSLog(@"printData %d - sid:%@, money:%@, get Or pay:%@, Date:%@, CategoryID:%@",k,[eb valueForKey:@"sid"],[eb valueForKey:@"money"],[eb valueForKey:@"get_pay"],[eb valueForKey:@"date"],[eb valueForKey:@"categories_sid"]);

        }
        NSLog(@"print: OK!");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DataController *dc = [[DataController alloc] init];
//    NSManagedObjectContext *mobc = [dc connectCoreData];
    NSLog(@"load array: %@",[dc loadFromCoreData]);
    
//    DataController *dataController = [[DataController alloc] init];
//    
//    NSArray *arr = [dataController loadFromCoreData];
//    NSLog(@"arr %@",arr);
    
//    NSManagedObjectContext *managedObjectContext = [self connectCoreData];
//
//    Items *item1 = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:managedObjectContext];
//    
//    NSDate *date = [NSDate new];
//    
//    item1.sid = 5;
//    [item1 setValue:@(12345) forKey:@"money"];
//    [item1 setValue:@(NO) forKey:@"get_pay"];
//    [item1 setValue:date forKey:@"date"];
//    [item1 setValue:@(1) forKey:@"categories_sid"];
//    
//    Categoried *cat1 = [NSEntityDescription insertNewObjectForEntityForName:@"Categoried" inManagedObjectContext:managedObjectContext];
//    
//    [cat1 setValue:@"4444" forKey:@"name"];
//    [cat1 setValue:@(1) forKey:@"sid"];
//    [cat1 setValue:@(0) forKey:@"parent_sid"];
//    
//    item1.category = cat1;
//    
//    
////    [cat1 addItemsObject:item1];
//    
//    [managedObjectContext save:nil];
//    
//    NSFetchRequest<Items*> *resoult =  [Items fetchRequest];
//    NSArray *resoultArray = [managedObjectContext executeFetchRequest:resoult error:nil];
//    Items *resoultItem = resoultArray[0];
//    
//
//    NSLog(@"category name: %@",[resoultItem.category valueForKey:@"name"]);

//    [self printData:managedObjectContext];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)save:(id)sender {
    
    DataController *dc = [[DataController alloc] init];
    NSManagedObjectContext *mobc = [dc connectCoreData];
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:mobc];
    item.index = [[NSUUID UUID] UUIDString];
    item.money = [_money.text intValue];
    item.io = [_getORpay isOn];
    

    
    Category *category = [NSEntityDescription insertNewObjectForEntityForName:@"Categoried" inManagedObjectContext:mobc];
    category.name = [_category text];
    category.index = 1;
    
    item.category = category;
    [mobc save:nil];
    
//    NSArray *resoult = [dc loadFromCoreData];
//    NSLog(@"resoult : %@",resoult);
//    
//    [self printData:mobc];
}
- (IBAction)printList:(id)sender {
    
    DataController *dc = [DataController new];
//    NSManagedObjectContext *mobc = [dc connectCoreData];
    NSArray<Item*> *arr = [dc loadFromCoreData];
    for (int i=0; i<arr.count; i++) {
    
        NSLog(@"%@.item:%@, money:%d, get or pay:%id, date: nil",arr[i].index,arr[i].category.name,arr[i].money,arr[i].io);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
