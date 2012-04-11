//
//  NSMutableArray+PhraseArray.m
//  Lastid
//
//  Created by David McCabe on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+PhraseArray.h"

@implementation NSMutableArray (PhraseArray)

+ (NSMutableArray *)phraseArrayFromString:(NSString *)aString
{
    NSCharacterSet *delimeters = [NSCharacterSet characterSetWithCharactersInString:@", \n\t"];
    NSMutableArray *tokens = [NSMutableArray arrayWithArray:[aString componentsSeparatedByCharactersInSet:delimeters]];
    [tokens removeObject:@""];
    [tokens removeObject:@" "];
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

@end
