//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSArray (ReducingToGroups)
- (NSArray *)arrayByReducingToGroupsWithFold:(id(^)(id,id))fold predicate:(BOOL(^)(id))predicate;
- (void)cheapAssUnitTest;
@end
