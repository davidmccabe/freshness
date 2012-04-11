//
//  NSMutableArray+PhraseArray.m
//  Lastid
//
//  Created by David McCabe on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+PhraseArray.h"
#import "NSString+Utilities.h"

@implementation NSMutableArray (PhraseArray)

+ (NSMutableArray *)phraseArrayFromString:(NSString *)aString
{
    NSMutableArray *tokens = [NSMutableArray arrayWithArray:[aString componentsSeparatedByDelimiters]];
    [tokens mapUsingSelector:@selector(stringByTrimmingDelimiters)];
    [tokens mapUsingSelector:@selector(capitalizedString)];
    [tokens filterUsingSelector:@selector(isOnlyDelimiters)];
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
