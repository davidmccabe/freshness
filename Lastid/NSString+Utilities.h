//
//  NSString+Utilities.h
//  Lastid
//
//  Created by David McCabe on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utilities)
- (NSArray *)componentsSeparatedByDelimiters;
- (NSString *)stringByTrimmingDelimiters;
- (BOOL)isOnlyDelimiters;
- (NSString *)firstInitialString;
@end
