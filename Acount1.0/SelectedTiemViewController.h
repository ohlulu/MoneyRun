//
//  SelectedTiemViewController.h
//  Where money run
//
//  Created by Ohlulu on 2017/6/14.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectedTiemViewControllerDelegate <NSObject>

- (void) didSelectedTime:(NSDate *)date;

@end

@interface SelectedTiemViewController : UIViewController
@property (nonatomic, weak) id<SelectedTiemViewControllerDelegate> delegate;

@end
