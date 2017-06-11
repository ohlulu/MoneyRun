//
//  AppDelegate.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/11.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "AddViewController.h"
#import "HistoryViewController.h"
//#import "AnalysisViewController.h"
#import "DataController.h"
#import "OHMoneyRunContent.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
@import GoogleMobileAds;
@import Firebase;





@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];
    [FIRApp configure];
    
    
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    
    NSLog(@"HOME PAHT : %@",NSHomeDirectory());
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isFirst = [defaults boolForKey:isFirstOpen];
    if (!isFirst) {
        
        DataController *dc = [DataController sharedInstance];
        
        [CATEGORY_LIST enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Category *category = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_CATEGORY inManagedObjectContext:dc.managedObjectContext];
            category.name = obj;
            category.index = [[NSDate date] timeIntervalSince1970];
            category.imageName = CATEGORY_IMAGE_NAME[idx];
            NSError *err = nil;
            [dc saveToCoreData];
            if (err) {
                NSLog(@"Error with init category list %luld: %@",(unsigned long)idx,CATEGORY_LIST[idx]);
            }
            
        }];
        
        [defaults setBool:YES forKey:isFirstOpen];
    }
    
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSLog(@"Version : %@",version);
    
    
    NSString *versionFromBox = [defaults stringForKey:shortVersion];
    if (![version isEqualToString:versionFromBox]) {
        [defaults setInteger:0 forKey:addBtnPressCount];
        [defaults setBool:NO forKey:isShowStoreReview];
        [defaults setValue:version forKey:shortVersion];
    }
    

    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed{
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Acount1_0"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
