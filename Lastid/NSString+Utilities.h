//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (Utilities)
- (BOOL)hasOnlyCharactersInSet:(NSCharacterSet *)theSet;
- (NSString *)stringWithFirstCharacter;
@end
