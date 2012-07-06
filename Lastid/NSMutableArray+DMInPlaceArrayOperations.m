//  Copyright (c) 2012 David McCabe. All rights reserved.

// An apologia:
// Blocks are syntactically ugly, HOM would take too long to implement.

#import "NSMutableArray+DMInPlaceArrayOperations.h"

@implementation NSMutableArray (DMInPlaceArrayOperations)

// Clang doesn't know that we're using performSelector: with selectors that return
// autoreleased objects, so it's worried about it causing a leak.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)DM_mapUsingSelector:(SEL)aSelector
{
    for (NSUInteger i = 0; i < self.count; i++) {
        [self replaceObjectAtIndex:i withObject:[[self objectAtIndex:i] performSelector:aSelector]];
    }
}

- (void)DM_mapUsingSelector:(SEL)aSelector withObject:(id)anObject
{
    for (NSUInteger i = 0; i < self.count; i++) {
        [self replaceObjectAtIndex:i withObject:[[self objectAtIndex:i] performSelector:aSelector withObject:anObject]];
    }
}

- (void)DM_rejectUsingSelector:(SEL)aSelector
{
    for (NSUInteger i = 0; i < self.count; i++) {
        if ([[self objectAtIndex:i] performSelector:aSelector]) {
            [self removeObjectAtIndex:i--];
        }
    }
}

- (void)DM_rejectUsingSelector:(SEL)aSelector withObject:(id)anObject
{
    for (NSUInteger i = 0; i < self.count; i++) {
        if ([[self objectAtIndex:i] performSelector:aSelector withObject:anObject]) {
            [self removeObjectAtIndex:i--];
        }
    }
}

#pragma clang diagnostic pop

@end
