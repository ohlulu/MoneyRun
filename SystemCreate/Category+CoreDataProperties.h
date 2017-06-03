//
//  Category+CoreDataProperties.h
//  Acount1.0
//
//  Created by 施翔日 on 2017/5/2.
//  Copyright © 2017年 ohlulu. All rights reserved.
//

#import "Category+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest;

@property (nonatomic) double index;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
