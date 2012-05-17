//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DMFood : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * lastAdded;

+ (DMFood *)enterFoodWithName:(NSString *)name;
+ (BOOL)foodExistsWhoseNameBeginsWith:(NSString *)prefix;

@end
