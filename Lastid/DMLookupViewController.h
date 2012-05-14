//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>

@class DMLookupViewController;

@protocol DMLookupViewControllerDelegate <NSObject>
- (void)lookupViewControllerDidFinish:(DMLookupViewController *)controller;
@end

@interface DMLookupViewController : UITableViewController <NSFetchedResultsControllerDelegate>
- (IBAction)addFoodsPressed:(UIBarButtonItem *)sender;
- (IBAction)sortControlDidChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@property (weak, nonatomic) id <DMLookupViewControllerDelegate> delegate;
@end
