//
//  DMSecondViewController.h
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
