//
//  AddViewController.h
//  Acount1.0
//
//  Created by 施翔日 on 2017/4/20.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+CoreDataProperties.h"
#define HIDE_ADDBUTTON_NOTIFICATION @"hide_addButton_Notification"
#define SHOW_ADDBUTTON_NOTIFICATION @"show_addButton_Notification"

@protocol AddViewControllerDelegate <NSObject>

-(void) didFinishEditItem:(Item *) item;

@end

@interface AddViewController : UIViewController

@property (nonatomic, weak) id<AddViewControllerDelegate> delegate;
@property (nonatomic) Item *currentItem;

@end
