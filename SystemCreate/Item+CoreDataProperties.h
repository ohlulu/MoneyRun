//
//  Item+CoreDataProperties.h
//  Acount1.0
//
//  Created by 施翔日 on 2017/5/2.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *index;
@property (nonatomic) BOOL io;
@property (nonatomic) int32_t money;
@property (nullable, nonatomic, copy) NSDate *trueDate;
@property (nullable, nonatomic, copy) NSString *formatDate;
@property (nullable, nonatomic, copy) NSString *remark;
@property (nullable, nonatomic, retain) Category *category;

@end

NS_ASSUME_NONNULL_END
