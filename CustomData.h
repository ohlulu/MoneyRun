//
//  CustomData.h
//  Acount1.0
//
//  Created by 施翔日 on 2017/5/4.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+CoreDataProperties.h"
@interface CustomData : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSMutableArray<Item *> *items;
@end
