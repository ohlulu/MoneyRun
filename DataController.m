//
//  DataController.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/19.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "DataController.h"
#import "OHMoneyRunContent.h"

@implementation DataController
{
    NSCalendar *calendar;
}

@synthesize persistentContainer = _persistentContainer;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Singelton

- (instancetype)init
{
    self = [super init];
    if (self) {
       _managedObjectContext = [self connectCoreData];
        calendar = [NSCalendar currentCalendar];
    }
    return self;
}

+ (instancetype) sharedInstance {
    
    static DataController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataController alloc] init];
    });
    
    return instance;
}

#pragma mark - Prepare for coredata

- (NSManagedObjectContext *) connectCoreData {
    
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:DB_NAME];
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *PersistentStoreDescription, NSError *error) {
        if (error) {
            NSLog(@"connect error: %@",error);
        } else {
            NSLog(@"connect OK!");
        }
    }];
    
    return _persistentContainer.viewContext;
}

- (void) saveContext {
    
//    NSManagedObjectContext *context = _persistentContainer.viewContext;
    NSError *err;
    if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&err]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", err, err.userInfo);
        // abort();
    }
    
}

#pragma mark - Load all and save all

- (NSArray *) loadFromCoreData {
    
    NSFetchRequest *requset = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    NSError *err;
    NSArray *results =  [_managedObjectContext executeFetchRequest:requset error:&err];
    if (err) {
        NSLog(@"fetch request error: %@",err);
    }
    
    return results;
}

- (void) saveToCoreData {
    NSError *err;
    [_managedObjectContext save:&err];
    if (err) {
        NSLog(@"save error: %@",err);
    }
}

#pragma mark - insert one item with category

- (void) insertItem:(Item *)item WithCategorylName:(NSString *)name {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_CATEGORY];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    [fetchRequest setPredicate:predicate];
    NSError *err;
    Category *result = [_managedObjectContext executeFetchRequest:fetchRequest error:&err][0];
    [result addItems:[NSSet setWithObject:item]];
    
    [self saveToCoreData];
    
}

#pragma mark - Get total money gourp by month

- (NSMutableArray *) getTotalMoneyGroupByMonth {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    
    NSEntityDescription *itemEntity = [NSEntityDescription entityForName:ENTITY_ITEM inManagedObjectContext:_managedObjectContext];
    NSAttributeDescription *itemWithFormatDate = [itemEntity.attributesByName objectForKey:@"formatDate"];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:itemWithFormatDate,nil]];
    [fetchRequest setPropertiesToGroupBy:@[itemWithFormatDate]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"trueDate" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err) {
        NSLog(@"getTotalMoneyGroupByMonth Error : %@",err);
    }
    
    __block NSString *monthTemp;
    __block NSMutableArray *numberArray = [NSMutableArray new];
    
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDateFormatter *format = [NSDateFormatter new];
        [format setLocale:[NSLocale currentLocale]];
        [format setDateStyle:NSDateFormatterLongStyle];
        [format setTimeStyle:NSDateFormatterNoStyle];
        
        NSDate *date = [format dateFromString:[obj valueForKey:@"formatDate"]];
        
        [format setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_MONTH
                                                              options:0
                                                               locale:[NSLocale currentLocale]]];
        NSString *monthString = [format stringFromDate:date];
        
        [format setDateFormat:[NSDateFormatter dateFormatFromTemplate:FORMAT_YEAR
                                                              options:0
                                                               locale:[NSLocale currentLocale]]];
        NSString *yearString = [format stringFromDate:date];
        
        if (![monthTemp isEqualToString:monthString] ) {
            CGFloat month = [[self sumOfMoneyWithMonth:monthString andYear:yearString] floatValue];
            CGFloat year = [[self sumOfMoneyWithYear:yearString] floatValue];
            NSNumber *percent = [NSNumber numberWithFloat:(month / year)];
            NSDictionary *data = @{@"year":yearString,@"month":monthString,@"money":[self sumOfMoneyWithMonth:monthString andYear:yearString],@"percentWithYear":percent};
            
            [numberArray addObject:data];
            monthTemp = monthString;
        }
    }];
    
    __block NSArray *arr = [numberArray valueForKeyPath:@"@distinctUnionOfObjects.year"];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj2 compare:obj1 options:NSNumericSearch];
    }];
    __block NSMutableArray *formatDatas = [NSMutableArray new];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year = %@",obj];
        [formatDatas addObject:[numberArray filteredArrayUsingPredicate:predicate]];
        
    }];
    NSLog(@"format Data %@" ,formatDatas);
    

    return formatDatas;
}

#pragma mark - Select Item group by Date

- (NSMutableArray<CustomData *> *) loadItemsGroupByFormatMonth:(NSString *) formatMonth andFormatYear:(NSString *)formatYear {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_ITEM inManagedObjectContext:_managedObjectContext];
    
    // Set SortDescriptor
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"trueDate" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateSort]];
    
    // Set AttributeDescription for Goup By
    NSAttributeDescription *itemWithFormatDate = [entity.attributesByName objectForKey:@"formatDate"];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:itemWithFormatDate, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:itemWithFormatDate]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Set contains serch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"formatDate CONTAINS[cd] %@ AND formatDate CONTAINS[cd] %@" ,formatMonth,formatYear];

    [fetchRequest setPredicate:predicate];
    
    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    if (err) {
        NSLog(@"load Items Group By FormatDate Error: %@",err);
    }
    
    __block NSMutableArray<CustomData *> *datas = [[NSMutableArray alloc] init];
    
    if (results.count==0) {
        return datas;
    }
    
    [results enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CustomData *section = [CustomData new];
        
        section.items = [[self loadItemsInDate:[obj valueForKey:@"formatDate"]] mutableCopy];
        
        if ([calendar isDateInToday:section.items[0].trueDate]) {
            section.title = NSLocalizedString(@"Today", @"Today");
        } else if ([calendar isDateInYesterday:section.items[0].trueDate]) {
            section.title = NSLocalizedString(@"Yesterday", @"Yesterday");
        } else if ([calendar isDateInTomorrow:section.items[0].trueDate]) {
            section.title = NSLocalizedString(@"Tomorrow", @"Tomorrow");
        } else {
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            
            NSString *customFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMdd eee" options:0 locale:[NSLocale currentLocale]];
            [formatter setDateFormat:customFormat];
            
            NSString *dateString = [formatter stringFromDate:section.items[0].trueDate];
            section.title = dateString;//[obj valueForKey:@"formatDate"];
        }
        [datas addObject:section];
        
    }];
    
    return datas;
    
}


#pragma mark - Get total money group by month

- (NSNumber *) sumOfMoneyWithMonth:(NSString *) month andYear:(NSString *) year {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_ITEM inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"money"];
    
    // Create an expression to represent the sum of marks
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"sum:"
                                                            arguments:@[keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"moneySum"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Creat a predicate to contains serch
    NSPredicate *predicate;
    if (month != nil) {
        predicate = [NSPredicate predicateWithFormat:@"formatDate CONTAINS[cd] %@ AND formatDate CONTAINS[cd] %@",month,year];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"formatDate CONTAINS[cd] %@",year];
    }
    
    [fetchRequest setPredicate:predicate];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSNumber *number = [result[0] valueForKey:@"moneySum"];
    
    
    return number;
}

- (NSNumber *) sumOfMoneyWithYear:(NSString *) year {
    return  [self sumOfMoneyWithMonth:nil andYear:year];
}


#pragma mark - Select Item equal Date(NSString *)

- (NSArray *) loadItemsInDate:(NSString *) date {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_ITEM inManagedObjectContext:managedContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"formatDate = %@",date];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    if (err) {
        NSLog(@"loadAllCategory Error: %@",err);
    }
    
    return results;
    
}

#pragma mark - Load all catefory in AddViewController

- (NSArray *) loadAllCategory {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_CATEGORY];
    
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[dateSort]];
    
    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    if (err) {
        NSLog(@"loadAllCategory Error: %@",err);
    }

    return results;
    
}

- (void) insertCategoryObjectWithCategoryName:(NSString *) name {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_CATEGORY];
    
    // Get category's mix index
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [fetchRequest setSortDescriptors:@[dateSort]];
    [fetchRequest setFetchLimit: 1];

    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err) {
        NSLog(@"loadAllCategory Error: %@",err);
    }
    
    Category *category = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_CATEGORY inManagedObjectContext:_managedObjectContext];
    category.name = name;
    category.index = [[results[0] valueForKey:@"index"] doubleValue]-0.87;
    category.imageName = @"nil";
    
    [self saveToCoreData];

    
}

- (NSArray *) getTotalMoneyGroupByCategoryNameFromDate:(NSDate *) startDate Todate:(NSDate *)endDate {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    NSPredicate *predicate = nil;
    
    
    predicate = [NSPredicate predicateWithFormat:@"trueDate >= %@ AND trueDate <= %@",startDate,endDate];

    [fetchRequest setPredicate:predicate];
    
    NSExpressionDescription *ex = [[NSExpressionDescription alloc] init];
    [ex setExpression:[NSExpression expressionWithFormat:@"@sum.money"]];
    [ex setName:@"sum"];
    [ex setExpressionResultType:NSDecimalAttributeType];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"category.name", ex, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:@"category.name"]];
    
    [fetchRequest setResultType:NSDictionaryResultType ];
    
    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err) {
        NSLog(@"fetch err %@",err);
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"sum" ascending:YES];
    
    results = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"results %@", results);
    
    return results;
    
    return nil;
}


- (NSArray *) getTotalMoneyGroupByCategoryNameWithMonth:(NSString *) month withYear:(NSString *) year{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_ITEM];
    NSPredicate *predicate = nil;
    
    predicate= [NSPredicate predicateWithFormat:@"formatDate CONTAINS[cd] %@ AND formatDate CONTAINS[cd] %@",month,year];

    [fetchRequest setPredicate:predicate];
    
    NSExpressionDescription *ex = [[NSExpressionDescription alloc] init];
    [ex setExpression:[NSExpression expressionWithFormat:@"@sum.money"]];
    [ex setName:@"sum"];
    [ex setExpressionResultType:NSDecimalAttributeType];

    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"category.name", ex, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:@"category.name"]];
    
    [fetchRequest setResultType:NSDictionaryResultType ];

    NSError *err;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&err];
    if (err) {
        NSLog(@"fetch err %@",err);
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"sum" ascending:YES];
    
    results = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return results;
}




- (void) dealloc {
    
    [self saveToCoreData];
    NSLog(@"DataController dealloc");
    
}





@end
