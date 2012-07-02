//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface DMFoodList : NSObject <NSFastEnumeration>

- (void)addFoodsFromString:(NSString *)string;
- (void)commit;

- (void)mergeNameAtIndex:(NSUInteger)firstIndex withNameAtIndex:(NSUInteger)secondIndex;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)newObject;

@end
