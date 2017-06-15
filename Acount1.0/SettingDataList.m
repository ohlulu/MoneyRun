//
//  SettingDataList.m
//  Where money run
//
//  Created by Ohlulu on 2017/6/14.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "SettingDataList.h"

@implementation SettingDataList

- (instancetype) initWithTitle:(NSString *) title detail:(NSMutableArray *)detail{
    self = [super init];
    if (self) {
        self.title = title;
        self.detail = detail;
    }
    
    return self;
}


@end
