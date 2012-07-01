//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSMutableArray+PhraseArray.h"
#import "NSString+Utilities.h"
#import "DMFood.h"
#import "NSMutableArray+InPlaceArrayOperations.h"

@implementation NSMutableArray (PhraseArray)

/*
 Attempts to clean up the given string as much as possible
 and returns an array of capitalized words or phrases, where the phrases
 are formed from consecutive words from the input that are thought to
 represent a single item.
*/
+ (NSMutableArray *)phraseArrayFromString:(NSString *)aString
{
    NSMutableArray *tokens = [NSMutableArray arrayWithArray:[aString componentsSeparatedByDelimiters]];
    [tokens mapUsingSelector:@selector(stringByTrimmingDelimiters)];
    [tokens mapUsingSelector:@selector(capitalizedString)];
    [tokens rejectUsingSelector:@selector(isOnlyDelimiters)];
    tokens = [tokens phraseArrayByJoiningExistingPhrases];
    return tokens;
}

- (void)mergePhraseAtIndex:(NSUInteger)firstIndex withPhraseAtIndex:(NSUInteger)secondIndex
{
    NSString *newPhrase = [NSString stringWithFormat:@"%@ %@",
                                    [self objectAtIndex:firstIndex],
                                    [self objectAtIndex:secondIndex]];

    [self replaceObjectAtIndex:firstIndex withObject:newPhrase];
    [self removeObjectAtIndex:secondIndex];
}

/*
 Joins adjacent words if the resulting phrase already exists in the database.
 E.g., if the database contains the phrases "Green Beans" and "Fresh Sheep Milk",
 then this maps
    ["Green", "Beans", "Juice", "Fresh", "Sheep", "Milk"]
 to
    ["Green Beans", "Juice", "Fresh Sheep Milk"].
*/
- (NSMutableArray *)phraseArrayByJoiningExistingPhrases
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    
	NSMutableArray *phrase = [NSMutableArray array];
	for(NSString *word in self) {
        NSMutableArray *attemptedNextPhrase = [[phrase arrayByAddingObject:word] mutableCopy];
		if ([DMFood foodExistsWhoseNameBeginsWith:[attemptedNextPhrase phraseString]]) {
            phrase = attemptedNextPhrase;
		} else {
            if(phrase.count) [result addObject:phrase];
			phrase = [NSMutableArray arrayWithObject:word];
        }
	}
	[result addObject:phrase];
    [result mapUsingSelector:@selector(phraseString)];
	return result;
}

- (NSString *)phraseString
{
    return [self componentsJoinedByString:@" "];
}

@end
