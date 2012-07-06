//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)hasOnlyCharactersInSet:(NSCharacterSet *)theSet
{
    return [theSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:self]];
}

- (NSString *)stringWithFirstCharacter
{
    return [self substringToIndex:1];
}

@end
