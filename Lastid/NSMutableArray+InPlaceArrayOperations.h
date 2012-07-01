//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSMutableArray (InPlaceArrayOperations)

- (void)mapUsingSelector:(SEL)aSelector;
- (void)rejectUsingSelector:(SEL)aSelector;

@end
