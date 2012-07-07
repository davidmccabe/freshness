//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSArray (DMReducingToGroups)
- (NSArray *)DM_arrayByReducingToGroupsWithFold:(id(^)(id,id))fold predicate:(BOOL(^)(id))predicate;
@end
