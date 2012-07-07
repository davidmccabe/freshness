#import <GHUnitIOS/GHUnit.h> 

#import "NSArray+DMReducingToGroups.h"

@interface DMReducingToGroupsTest : GHTestCase
@end

@implementation DMReducingToGroupsTest

- (void)testReducingToGroups
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
    GHAssertEqualObjects(res, abc_de, nil);
    
    // Grouping an empty array should yield an empty array.
    res = [[NSArray array] DM_arrayByReducingToGroupsWithFold:appender predicate:shorterThanFour];
    GHAssertEqualObjects(res, [NSArray array], nil);
    
    // Grouping an array with one object should yield a copy of the receiver with a true predicate.
    res = [oneElement DM_arrayByReducingToGroupsWithFold:appender predicate:shorterThanFour];
    GHAssertEqualObjects(res, oneElement, nil);
    
    // Grouping an array with one object should yield a copy of the receiver with a false predicate.
    res = [oneElement DM_arrayByReducingToGroupsWithFold:appender predicate:alwaysFalse];
    GHAssertEqualObjects(res, oneElement, nil);
    
    // An always-false predicate should yield a copy of the receiver.
    res = [abcde DM_arrayByReducingToGroupsWithFold:appender predicate:alwaysFalse];
    GHAssertEqualObjects(res, abcde, nil);
}

@end
