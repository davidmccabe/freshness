//
//  NSMutableArray+PhraseArray.h
//  Lastid
//
//  Created by David McCabe on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (PhraseArray)
+ (NSMutableArray *)phraseArrayFromString:(NSString *)aString;
- (void)mergePhraseAtIndex:(NSUInteger)firstIndex withPhraseAtIndex:(NSUInteger)secondIndex;
@end
