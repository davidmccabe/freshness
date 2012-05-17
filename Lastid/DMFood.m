//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMFood.h"
#import "DMAppDelegate.h"

@implementation DMFood

@dynamic name;
@dynamic lastAdded;

+ (DMFood *)enterFoodWithName:(NSString *)name
{
    if ([name isEqualToString:@""]) return nil;
    
    DMFood *food = [DMFood MR_findFirstByAttribute:@"name" withValue:name];
    if (!food) {
        food = [DMFood MR_createEntity];
        food.name = name;
    }
    [food setLastAdded:[NSDate date]];
    return food;
}

+ (BOOL)foodExistsWhoseNameBeginsWith:(NSString *)prefix
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name beginswith %@", prefix];
    return [DMFood MR_countOfEntitiesWithPredicate:p] > 0;
}

@end
