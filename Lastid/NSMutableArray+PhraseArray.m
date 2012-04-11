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

@end
