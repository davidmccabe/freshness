//
//  NSCharacterSet+Delimeters.m
//  Lastid
//
//  Created by David McCabe on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSCharacterSet+Delimeters.h"

@implementation NSCharacterSet (Delimeters)
+ (NSCharacterSet *)delimitersCharacterSet
{
    NSMutableCharacterSet *s = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [s formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    return s;
}
@end
