//
//  CategoryAddViewController.h
//  Acount1.0
//
//  Created by Ohlulu on 2017/5/11.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryAddViewControllerDelegate <NSObject>

- (void)didAddCategory;

@end

@interface CategoryAddViewController : UIViewController

@property (nonatomic, weak) id<CategoryAddViewControllerDelegate> delegate;

@end
