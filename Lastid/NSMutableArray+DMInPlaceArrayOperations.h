//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSMutableArray (DMInPlaceArrayOperations)

- (void)DM_mapUsingSelector:(SEL)aSelector;
- (void)DM_mapUsingSelector:(SEL)aSelector withObject:(id)anObject;
- (void)DM_rejectUsingSelector:(SEL)aSelector;
- (void)DM_rejectUsingSelector:(SEL)aSelector withObject:(id)anObject;

@end
