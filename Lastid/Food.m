//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "Food.h"
#import "DMAppDelegate.h"

@implementation Food

@dynamic name;
@dynamic lastAdded;

+ (Food *)enterFoodWithName:(NSString *)name
{
    if ([name isEqualToString:@""]) return nil;
    
    Food *food = [Food MR_findFirstByAttribute:@"name" withValue:name];
    if (!food) {
        food = [Food MR_createEntity];
        food.name = name;
    }
    [food setLastAdded:[NSDate date]];
    return food;
}

+ (BOOL)foodExistsWhoseNameHasPrefix:(NSString *)prefix
{
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name beginswith %@", prefix];
    return [Food MR_countOfEntitiesWithPredicate:p] > 0;
}

@end
