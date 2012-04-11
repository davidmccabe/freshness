//
//  NSString+Utilities.m
//  Lastid
//
//  Created by David McCabe on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)
- (BOOL)isBlank
{
    return [@"" isEqualToString:[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
@end
