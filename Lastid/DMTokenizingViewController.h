//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>

@class DMTokenizingViewController;

@protocol DMTokenizingViewControllerDelegate <NSObject>
- (NSString *) stringToBeTokenized;
@end

@interface DMTokenizingViewController : UITableViewController <UITextFieldDelegate>
- (IBAction)donePressed:(id)sender;
- (IBAction)addPressed:(id)sender;
@property (weak, nonatomic) id <DMTokenizingViewControllerDelegate> delegate;
@end
