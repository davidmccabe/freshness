//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSMutableArray (PhraseArray)
+ (NSMutableArray *)phraseArrayFromString:(NSString *)aString;
- (void)mergePhraseAtIndex:(NSUInteger)firstIndex withPhraseAtIndex:(NSUInteger)secondIndex;
@end
