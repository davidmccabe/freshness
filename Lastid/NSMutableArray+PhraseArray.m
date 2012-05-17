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
    [tokens filterUsingSelector:@selector(isOnlyDelimiters)];
    tokens = [tokens phraseArrayByJoiningExistingPhrases];
    return tokens;
}

- (void)mergePhraseAtIndex:(NSUInteger)firstIndex withPhraseAtIndex:(NSUInteger)secondIndex
{
    NSString *firstPhrase = [self objectAtIndex:firstIndex];
    NSString *secondPhrase = [self objectAtIndex:secondIndex];
    NSString *newPhrase = [NSString stringWithFormat:@"%@ %@", firstPhrase, secondPhrase];
    
    [self replaceObjectAtIndex:firstIndex withObject:newPhrase];
    [self removeObjectAtIndex:secondIndex];
}

- (NSMutableArray *)phraseArrayByJoiningExistingPhrases
{
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    
	NSMutableArray *phrase = [NSMutableArray array];
	for(NSString *word in self) {
        NSArray *attemptedNextPhrase = [phrase arrayByAddingObject:word];
        BOOL isPrefixOfExistingName = [DMFood foodExistsWhoseNameBeginsWith:[attemptedNextPhrase componentsJoinedByString:@" "]];
		if (! isPrefixOfExistingName ) {
			if(phrase.count > 0) [result addObject:phrase];
			phrase = [NSMutableArray array];
		}
        phrase = [NSMutableArray arrayWithArray:[phrase arrayByAddingObject:word]];
	}
	[result addObject:phrase];
    [result mapUsingSelector:@selector(componentsJoinedByString:) withObject:@" "];
	return result;
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

- (void)mapUsingSelector:(SEL)aSelector withObject:(id)anObject
{
    for (NSUInteger i = 0; i < self.count; i++) {
        [self replaceObjectAtIndex:i withObject:[[self objectAtIndex:i] performSelector:aSelector withObject:anObject]];
    }
}

- (void)filterUsingSelector:(SEL)aSelector
{
    for (NSUInteger i = 0; i < self.count; i++) {
        if ([[self objectAtIndex:i] performSelector:aSelector]) {
            [self removeObjectAtIndex:i--];
        }
    }
}

#pragma clang diagnostic pop

@end
