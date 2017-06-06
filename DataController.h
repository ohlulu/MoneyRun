//
//  DataController.h
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/19.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Item+CoreDataClass.h"
#import "Item+CoreDataProperties.h"
#import "Category+CoreDataClass.h"
#import "Category+CoreDataProperties.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "CustomData.h"

#define DB_NAME @"Acount1_0"
#define ENTITY_CATEGORY @"Category"
#define ENTITY_ITEM @"Item"
#define COREDATA_HASCHANGE_NOTIFICATION @"coreData_hasChange_notification"

@interface DataController : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;

// Singleton
+ (instancetype) sharedInstance;

// Not must?
- (NSManagedObjectContext *) connectCoreData;
- (void) saveContext;
- (void) saveToCoreData;

// Load All Item
- (NSArray *) loadFromCoreData;

// Return cateory list
- (NSArray *) loadAllCategory;

// Select Item equal Date(NSString *)
- (NSArray *) loadItemsInDate:(NSString *) date;

// Insert Item with category name
- (void) insertItem:(Item *)item WithCategorylName:(NSString *)name;

// Load items group by attributes in formatDate
//- (NSMutableArray *) loadItemsGroupByFormatDate:(NSString *) formatDate;
- (NSMutableArray<CustomData *> *) loadItemsGroupByFormatMonth:(NSString *) formatMonth andFormatYear:(NSString *)formatYear;

// Get total money group by month
- (NSNumber *) sumOfMoneyWithMonth:(NSString *) month andYear:(NSString *) year;

// Inset a new category in mix index
- (void) insertCategoryObjectWithCategoryName:(NSString *) name;

- (NSArray *) getTotalMoneyGroupByCategoryNameWithDateRang:(NSString *) dateRang withFormatYear:(NSString *)formatYear segment:(NSInteger)segment;

- (NSArray *) getTotalMoneyGroupByCategoryNameFromDate:(NSDate *) startDate Todate:(NSDate *)endDate;

@end
