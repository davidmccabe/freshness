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

- (void)cheapAssUnitTest
{
    id abcde = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", nil];
    id abc_de = [NSArray arrayWithObjects:@"abc", @"de", nil];
    id oneElement = [NSArray arrayWithObject:@"foo"];
    id res;

    id (^appender)(id,id) = ^(id a, id b){ return [a stringByAppendingString:b];};
    BOOL (^shorterThanFour)(id) = ^BOOL(id string){ return [string length] < 4; };
    BOOL (^alwaysFalse)(id) = ^(id string) { return NO; };
    
    // Basic case.
    res = [abcde DM_arrayByReducingToGroupsWithFold:appender predicate:shorterThanFour];
    assert([res isEqualToArray:abc_de]);
    
    // Grouping an empty array should yield an empty array.
    res = [[NSArray array] DM_arrayByReducingToGroupsWithFold:appender predicate:shorterThanFour];
    assert([res count] == 0);
    
    // Grouping an array with one object should yield a copy of the receiver with a true predicate.
    res = [oneElement DM_arrayByReducingToGroupsWithFold:appender predicate:shorterThanFour];
    assert([res isEqualToArray:oneElement]);
    
    // Grouping an array with one object should yield a copy of the receiver with a false predicate.
    res = [oneElement DM_arrayByReducingToGroupsWithFold:appender predicate:alwaysFalse];
    assert([res isEqualToArray:oneElement]);
    
    // An always-false predicate should yield a copy of the receiver.
    res = [abcde DM_arrayByReducingToGroupsWithFold:appender predicate:alwaysFalse];
    assert([res isEqualToArray:abcde]);
}


@end
