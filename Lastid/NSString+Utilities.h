//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (Utilities)
- (NSArray *)componentsSeparatedByDelimiters;
- (NSString *)stringByTrimmingDelimiters;
- (BOOL)isOnlyDelimiters;
- (NSString *)stringWithFirstCharacter;
@end
