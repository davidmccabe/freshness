//
//  Food.m
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Food.h"
#import "DMAppDelegate.h"

@implementation Food

@dynamic name;
@dynamic lastAdded;

+ (Food *)enterFoodWithName:(NSString *)name
{
    Food *food = [Food MR_findFirstByAttribute:@"name" withValue:name];
    if (!food) {
        food = [Food MR_createEntity];
        food.name = name;
    }
    [food setLastAdded:[NSDate date]];
    return food;
}

@end
