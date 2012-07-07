#import <GHUnitIOS/GHUnit.h> 

#import "DMFood.h"
#import "DMFoodList.h"

@interface DMFoodList (PrivateMethodsNeededForTesting)
@property (strong, nonatomic) NSMutableArray *foodNames;
@end

@interface DMFoodListTest : GHTestCase
@end

@implementation DMFoodListTest

- (void)setUp
{
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
    [DMFood enterFoodWithName:@"Green Beans"];
    [DMFood enterFoodWithName:@"Fresh Sheep Milk"];
    [DMFood enterFoodWithName:@"Lettuce"];
    [DMFood enterFoodWithName:@"Juice"];
}    

- (void)tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void)testAddFoodsFromString
{
    NSDictionary *cases = [NSDictionary dictionaryWithObjectsAndKeys:
        // Test existing names, non-existing names, and names that begin with
        // the same word as an existing name but don't continue in kind.
        @"Green Beans Ambergris Fresh Sheep Milk Fresh Lettuce Juice",
        [NSArray arrayWithObjects:@"Green Beans", @"Ambergris", @"Fresh Sheep Milk", @"Fresh", @"Lettuce", @"Juice", nil],

        // Empty string should give an empty list.
        @"",
        [NSArray array],
        
        // Redundent whitespace and commas should be removed; words should be capitalized.
        @"lower-case letters, commas    etc.",
        [NSArray arrayWithObjects:@"Lower-Case", @"Letters", @"Commas", @"Etc.", nil],
    nil];
    
    [cases enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        DMFoodList *list = [[DMFoodList alloc] init];
        [list addFoodsFromString:obj];
        GHAssertEqualObjects(list.foodNames, key, nil);
    }];
}

- (void)testCommit
{
    DMFoodList *list = [[DMFoodList alloc] init];
    [list addObject:@"Foo"];
    [list addObject:@"Bar"];
    [list addObject:@"Baz"];
    [list removeObjectAtIndex:2];
    
    [list commit];
    
    GHAssertNotNil([DMFood MR_findFirstByAttribute:@"name" withValue:@"Foo"], nil);
    GHAssertNotNil([DMFood MR_findFirstByAttribute:@"name" withValue:@"Bar"], nil);
    GHAssertNil   ([DMFood MR_findFirstByAttribute:@"name" withValue:@"Baz"], nil);
}

- (void)testMergeNameAtIndexWithNameAtIndex
{
    DMFoodList *list = [[DMFoodList alloc] init];
    [list addObject:@"Foo"];
    [list addObject:@"Bar"];
    [list mergeNameAtIndex:0 withNameAtIndex:1];
    GHAssertTrue([list count] == 1, nil);
    GHAssertEqualObjects([list objectAtIndex:0], @"Foo Bar", nil);
}

@end
