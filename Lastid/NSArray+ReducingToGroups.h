//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSArray (ReducingToGroups)
- (NSArray *)arrayByReducingToGroupsByInitial:(id)initial combiner:(id(^)(id,id))combiner predicate:(BOOL(^)(id))predicate;
- (void)cheapAssUnitTest;
@end
