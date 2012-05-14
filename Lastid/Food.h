//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Food : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastAdded;

+ (Food *)enterFoodWithName:(NSString *)name;
+ (BOOL)foodExistsWhoseNameHasPrefix:(NSString *)prefix;

@end
