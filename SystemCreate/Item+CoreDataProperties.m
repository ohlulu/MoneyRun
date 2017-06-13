//
//  Item+CoreDataProperties.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/5/2.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic index;
@dynamic io;
@dynamic money;
@dynamic trueDate;
@dynamic formatDate;
@dynamic category;
@dynamic remark;

@end
