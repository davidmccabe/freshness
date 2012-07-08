//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSString+DMUtilities.h"

@implementation NSString (DMUtilities)

- (BOOL)DM_hasOnlyCharactersInSet:(NSCharacterSet *)theSet
{
    return [theSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:self]];
}

- (NSString *)DM_stringWithFirstCharacter
{
    return [self substringWithRange:[self rangeOfComposedCharacterSequenceAtIndex:0]];
}

@end
