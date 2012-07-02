//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMFoodList.h"
#import "NSString+Utilities.h"
#import "DMFood.h"
#import "NSMutableArray+InPlaceArrayOperations.h"

@interface DMFoodList ()
@property (strong, nonatomic) NSMutableArray *foodNames;
@end

@implementation DMFoodList

@synthesize foodNames;

- (id)init
{
    if (self = [super init]) {
        self.foodNames = [NSMutableArray array];
    }
    return self;
}

- (void)addFoodsFromString:(NSString *)string
{
    NSMutableArray *names = [[string componentsSeparatedByDelimiters] mutableCopy];
    [names mapUsingSelector:@selector(stringByTrimmingDelimiters)];
    [names mapUsingSelector:@selector(capitalizedString)];
    [names rejectUsingSelector:@selector(isOnlyDelimiters)];
    names = [self nameArrayByJoiningExistingNamesInArray:names];
    [self.foodNames addObjectsFromArray:names];
}

/*
 Joins adjacent words if the resulting phrase already exists in the database.
 E.g., if the database contains the phrases "Green Beans" and "Fresh Sheep Milk",
 then this maps
 ["Green", "Beans", "Juice", "Fresh", "Sheep", "Milk"]
 to
 ["Green Beans", "Juice", "Fresh Sheep Milk"].
*/
- (NSMutableArray *)nameArrayByJoiningExistingNamesInArray:(NSArray *)names
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[names count]];
    
    NSString *phrase = @"";
	for(NSString *word in names) {
        NSString *attemptedNextPhrase = [phrase stringByAppendingFormat:@" %@", word];
		if ([DMFood foodExistsWhoseNameBeginsWith:attemptedNextPhrase]) {
            phrase = attemptedNextPhrase;
		} else {
            if(phrase.length > 0) [result addObject:phrase];
			phrase = word;
        }
	}
	[result addObject:phrase];
	return result;
}

- (void)commit
{
    for (NSString *name in self.foodNames) {
        [DMFood enterFoodWithName:name];
    }
}

- (void)mergeNameAtIndex:(NSUInteger)firstIndex withNameAtIndex:(NSUInteger)secondIndex
{
    NSString *newPhrase = [NSString stringWithFormat:@"%@ %@",
                           [self.foodNames objectAtIndex:firstIndex],
                           [self.foodNames objectAtIndex:secondIndex]];
    
    [self.foodNames replaceObjectAtIndex:firstIndex withObject:newPhrase];
    [self.foodNames removeObjectAtIndex:secondIndex];
}

#pragma mark ARRAY EMULATION

- (NSUInteger)count
{
    return self.foodNames.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.foodNames objectAtIndex:index];
}

- (void)addObject:(id)object
{
    [self.foodNames addObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [self.foodNames removeObjectAtIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)newObject
{
    [self.foodNames replaceObjectAtIndex:index withObject:newObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id *)stackbuf count:(NSUInteger)len
{
    return [self.foodNames countByEnumeratingWithState:state objects:stackbuf count:len];
}

@end
