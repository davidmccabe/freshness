//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMFoodList.h"
#import "DMFood.h"
#import "NSString+DMUtilities.h"
#import "NSMutableArray+DMInPlaceArrayOperations.h"
#import "NSArray+DMReducingToGroups.h"

@interface DMFoodList ()
@property (strong, nonatomic) NSMutableArray *foodNames;
@property (strong, nonatomic) NSMutableCharacterSet *delimiters;
@end

@implementation DMFoodList

@synthesize foodNames;
@synthesize delimiters;

- (id)init
{
    if (self = [super init]) {
        self.foodNames = [NSMutableArray array];
        
        self.delimiters = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [self.delimiters formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    }
    return self;
}

- (void)addFoodsFromString:(NSString *)string
{
    NSMutableArray *names = [[string componentsSeparatedByCharactersInSet:self.delimiters] mutableCopy];
    [names DM_mapUsingSelector:@selector(stringByTrimmingCharactersInSet:) withObject:self.delimiters];
    [names DM_mapUsingSelector:@selector(capitalizedString)];
    [names DM_rejectUsingSelector:@selector(DM_hasOnlyCharactersInSet:) withObject:self.delimiters];
    names = [[self nameArrayByJoiningExistingNamesInArray:names] mutableCopy];
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
- (NSArray *)nameArrayByJoiningExistingNamesInArray:(NSArray *)names
{
    return [names DM_arrayByReducingToGroupsWithFold:^(id name, id word) { return [name stringByAppendingFormat:@" %@", word]; }
                                           predicate:^(id name)          { return [DMFood foodExistsWhoseNameBeginsWith:name]; }];
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
