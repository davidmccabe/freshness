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

+ (void)enterFoodWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    
}

+ (Food *)foodWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Food" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == '%@'", name];
    [request setPredicate:predicate];
        
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (results == nil || [results count] == 0) {
        return nil;
    } else {
        return [results objectAtIndex:0];
    }
}

@end
