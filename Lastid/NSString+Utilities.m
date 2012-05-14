//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSString+Utilities.h"
#import "NSCharacterSet+Delimeters.h"

@implementation NSString (Utilities)
- (NSArray *)componentsSeparatedByDelimiters
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet delimitersCharacterSet]];
}
- (NSString *)stringByTrimmingDelimiters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet delimitersCharacterSet]];
}
- (BOOL)isOnlyDelimiters
{
    return [@"" isEqualToString:[self stringByTrimmingDelimiters]];
}

- (NSString *)firstInitialString
{
    if (self.length == 0 || self.length == 1)
        return self;
    else
        return [self substringToIndex:1];
}

@end
