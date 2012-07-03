//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSArray+ReducingToGroups.h"

@implementation NSArray (ReducingToGroups)

/*
    Groups together consecutive items as long as the resulting groups satisfy the predicate.
    E.g.:
    
     id array = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", nil];
     
     id res = [array arrayByReducingToGroupsByInitial:@""
                     combiner:^(id a, id b)    { return [a stringByAppendingString:b];}
                    predicate:^BOOL(id string) { return [string length] < 4; }];
     
     [res description] => ("abc", "de")
 
    Will not include 'initial' at the beginning of the resulting array
    even if the predicate fails for the first item alone.
*/
- (NSArray *)arrayByReducingToGroupsByInitial:(id)initial combiner:(id(^)(id,id))combiner predicate:(BOOL(^)(id))predicate
{
	NSMutableArray *result = [NSMutableArray array];
    
    id group = initial;
    BOOL firstTime = YES;
    for(id item in self) {
        id nextAttemptedGroup = combiner(group, item);
        if (predicate(nextAttemptedGroup)) {
            group = nextAttemptedGroup;
        } else {
            if (!firstTime) [result addObject:group];
            group = item;
        }
        firstTime = NO;
    }
    [result addObject:group];
    
    return result;
}

- (void)cheapAssUnitTest
{
    id abcde = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", nil];
    id res;
    BOOL valid;

    id (^appender)(id,id) = ^(id a, id b){ return [a stringByAppendingString:b];};
    BOOL (^shorterThanFour)(id) = ^BOOL(id string){ return [string length] < 4; };
    BOOL (^alwaysFalse)(id) = ^(id string) { return NO; };
    
    // Basic case.
    res = [abcde arrayByReducingToGroupsByInitial:@"" combiner:appender predicate:shorterThanFour];
    valid = [res isEqualToArray:[NSArray arrayWithObjects:@"abc",@"de",nil]];
    assert(valid);
    
    // Grouping an empty array should yield an empty array.
    res = [[NSArray array] arrayByReducingToGroupsByInitial:@"" combiner:appender predicate:shorterThanFour];
    assert([res count] == 0);
    
    // Predicate never true should yield a copy of the receiver.
    res = [abcde arrayByReducingToGroupsByInitial:@"" combiner:appender predicate:alwaysFalse];
    valid = [res isEqualToArray:abcde];
    assert(valid);
}


@end
