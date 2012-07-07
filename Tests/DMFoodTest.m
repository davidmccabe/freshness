#import <GHUnitIOS/GHUnit.h> 

#import "DMFood.h"

BOOL dateIsCurrent(NSDate *date)
{
    return fabs([date timeIntervalSinceNow]) < 1; // second.
}

@interface DMFoodTest : GHTestCase
@end

@implementation DMFoodTest

- (void)setUp
{
    [MagicalRecordHelpers setupCoreDataStack];
    [DMFood MR_deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    DMFood *f = [DMFood MR_createEntity];
    f.name = @"Green Beans";
    f.lastAdded = [NSDate distantPast];
}

- (void)tearDown
{
    [MagicalRecordHelpers cleanUp];
}

- (void)testEnterFoodWithName
{
    DMFood *existing = [DMFood enterFoodWithName:@"Green Beans"];
    GHAssertEqualObjects(existing.name, @"Green Beans", nil);
    GHAssertTrue(dateIsCurrent(existing.lastAdded), nil);
    
    DMFood *new = [DMFood enterFoodWithName:@"Mascarpone"];
    GHAssertEqualObjects(new.name, @"Mascarpone", nil);
    GHAssertTrue(dateIsCurrent(new.lastAdded), nil);
    
    DMFood *invalidName = [DMFood enterFoodWithName:@""];
    GHAssertNil(invalidName, nil);
}

- (void)testFoodExistsWhoseNameBeginsWith
{
    GHAssertTrue ([DMFood foodExistsWhoseNameBeginsWith:@"Green"], nil);
    GHAssertFalse([DMFood foodExistsWhoseNameBeginsWith:@"Beans"], nil);
}

@end
