//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "NSCharacterSet+Delimeters.h"

@implementation NSCharacterSet (Delimeters)
+ (NSCharacterSet *)delimitersCharacterSet
{
    NSMutableCharacterSet *s = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [s formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    return s;
}
@end
