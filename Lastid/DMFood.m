//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMFood.h"
#import "DMAppDelegate.h"

@implementation DMFood

@dynamic name;
@dynamic lastAdded;

/*
 For a valid food name, ensures that a food entity with that
 name exists and that its lastAdded date is the current date.
 Returns the food or NULL if the given name is invalid.
 (As of writing only the empty string is invalid.)
*/
+ (DMFood *)enterFoodWithName:(NSString *)name
{
    DMFood *food = [DMFood MR_findFirstByAttribute:@"name" withValue:name];
    if (!food) {
        food = [DMFood MR_createEntity];
        food.name = name;
    }
    food.lastAdded = [NSDate date];

    if ([food validateForUpdate:NULL]) {
        return food;
    } else {
        [food MR_deleteEntity];
        return NULL;
    }
}

+ (BOOL)foodExistsWhoseNameBeginsWith:(NSString *)prefix
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name beginswith %@", prefix];
    return [DMFood MR_countOfEntitiesWithPredicate:p] > 0;
}

@end
