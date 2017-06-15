//
//  SettingDataList.h
//  Where money run
//
//  Created by Ohlulu on 2017/6/14.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDataList : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSMutableArray *detail;

- (instancetype) initWithTitle:(NSString *) title detail:(NSMutableArray *)detail;

@end
