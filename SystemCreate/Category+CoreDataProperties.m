//
//  Category+CoreDataProperties.m
//  Acount1.0
//
//  Created by 施翔日 on 2017/5/2.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "Category+CoreDataProperties.h"

@implementation Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Category"];
}

@dynamic index;
@dynamic name;
@dynamic imageName;
@dynamic items;

@end
