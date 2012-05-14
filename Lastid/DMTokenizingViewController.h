//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>

@class DMTokenizingViewController;

@protocol DMTokenizingViewControllerDelegate <NSObject>
- (NSString *) stringToBeTokenized;
- (void) tokenizingViewControllerDidCancel;
- (void) tokenizingViewControllerDidYieldPhrases:(NSArray *)phrases;
@end

@interface DMTokenizingViewController : UITableViewController <UITextFieldDelegate>
- (IBAction)cancelPressed:(id)sender;
- (IBAction)donePressed:(id)sender;
- (IBAction)addPressed:(id)sender;
@property (weak, nonatomic) id <DMTokenizingViewControllerDelegate> delegate;
@end
