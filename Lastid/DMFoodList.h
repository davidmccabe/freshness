//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface DMFoodList : NSObject <NSFastEnumeration>

+ (DMFoodList *)foodListFromString:(NSString *)string;

- (void)commit;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (void)addObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)newObject;

- (void)mergeNameAtIndex:(NSUInteger)firstIndex withNameAtIndex:(NSUInteger)secondIndex;

@end
