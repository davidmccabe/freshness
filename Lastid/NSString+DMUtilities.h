//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (DMUtilities)
- (BOOL)DM_hasOnlyCharactersInSet:(NSCharacterSet *)theSet;
- (NSString *)DM_stringWithFirstCharacter;
@end
