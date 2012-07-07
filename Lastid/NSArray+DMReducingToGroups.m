//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSArray+DMReducingToGroups.h"

@implementation NSArray (DMReducingToGroups)

/*
 Groups together consecutive items as long as the resulting groups satisfy the predicate.
 E.g.:
 
 id array = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", nil];
 
 id res = [array arrayByReducingToGroupsWithFold:^(id a, id b)    { return [a stringByAppendingString:b];}
                                       predicate:^BOOL(id string) { return [string length] < 4; }];
 
 [res description] => ("abc", "de")

 */
- (NSArray *)DM_arrayByReducingToGroupsWithFold:(id(^)(id,id))fold predicate:(BOOL(^)(id))predicate
{
    if (self.count == 0) return [NSArray array];
    
	NSMutableArray *result = [NSMutableArray array];

    id group = [self objectAtIndex:0];
    for (int i = 1; i < self.count; i++) {
        id item = [self objectAtIndex:i];
        id nextAttemptedGroup = fold(group,item);
        if (predicate(nextAttemptedGroup)) {
            group = nextAttemptedGroup;
        } else {
            [result addObject:group];
            group = item;
        }
    }
    [result addObject:group];
    
    return result;
}

@end
