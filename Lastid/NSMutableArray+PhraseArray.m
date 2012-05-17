//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSMutableArray+PhraseArray.h"
#import "NSString+Utilities.h"
#import "DMFood.h"

@implementation NSMutableArray (PhraseArray)

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

- (NSMutableArray *)phraseArrayByJoiningExistingPhrases
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    
	NSMutableArray *phrase = [NSMutableArray array];
	for(NSString *word in self) {
        NSMutableArray *attemptedNextPhrase = [[phrase arrayByAddingObject:word] mutableCopy];
		if (! [DMFood foodExistsWhoseNameBeginsWith:[attemptedNextPhrase phraseString]] ) {
            [result addObject:phrase];
			phrase = [NSMutableArray arrayWithObject:word];
		} else {
            phrase = attemptedNextPhrase;
        }
	}
	[result addObject:phrase];
    [result mapUsingSelector:@selector(phraseString)];
    [result rejectUsingSelector:@selector(isOnlyDelimiters)];
	return result;
}

- (NSString *)phraseString
{
    return [self componentsJoinedByString:@" "];
}

// Clang doesn't know that we're using performSelector: with selectors that return
// autoreleased objects, so it's worried about it causing a leak.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)mapUsingSelector:(SEL)aSelector
{
    for (NSUInteger i = 0; i < self.count; i++) {
        [self replaceObjectAtIndex:i withObject:[[self objectAtIndex:i] performSelector:aSelector]];
    }
}

- (void)rejectUsingSelector:(SEL)aSelector
{
    for (NSUInteger i = 0; i < self.count; i++) {
        if ([[self objectAtIndex:i] performSelector:aSelector]) {
            [self removeObjectAtIndex:i--];
        }
    }
}

#pragma clang diagnostic pop

@end
