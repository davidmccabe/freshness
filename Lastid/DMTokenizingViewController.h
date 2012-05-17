//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>

@interface DMTokenizingViewController : UITableViewController <UITextFieldDelegate>
- (IBAction)donePressed:(id)sender;
- (IBAction)addPressed:(id)sender;
- (void)setStringToBeTokenized:(NSString *)theString;
@end
