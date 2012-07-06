//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSMutableArray (InPlaceArrayOperations)

- (void)mapUsingSelector:(SEL)aSelector;
- (void)mapUsingSelector:(SEL)aSelector withObject:(id)anObject;
- (void)rejectUsingSelector:(SEL)aSelector;
- (void)rejectUsingSelector:(SEL)aSelector withObject:(id)anObject;

@end
