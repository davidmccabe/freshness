//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>

@interface DMLookupViewController : UITableViewController <NSFetchedResultsControllerDelegate>
- (IBAction)sortControlDidChange:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@end
