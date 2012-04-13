//
//  DMTokenizingViewController.h
//  Lastid
//
//  Created by David McCabe on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
@property (weak, nonatomic) id <DMTokenizingViewControllerDelegate> delegate;
@end
