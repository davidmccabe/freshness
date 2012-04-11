//
//  DMTokenizingViewController.m
//  Lastid
//
//  Created by David McCabe on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMTokenizingViewController.h"

@interface DMTokenizingViewController ()
@property (strong, nonatomic) NSArray *phrases;
@end

@implementation DMTokenizingViewController

@synthesize phrases;

@synthesize delegate;
- (void)setDelegate:(id<DMTokenizingViewControllerDelegate>)aDelegate
{
    delegate = aDelegate;
    [self setInitialPhrasesFromString: [delegate stringToBeTokenized]];
}

- (void)setInitialPhrasesFromString:(NSString *)aString
{
    self.phrases = [aString componentsSeparatedByString:@" "];
}

- (void)viewDidLoad
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleJoinGesture:)];
    recognizer.minimumPressDuration = 0.1;
    recognizer.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)handleJoinGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateEnded) return;
    if (recognizer.numberOfTouches != 2) return;
    
    NSUInteger row1 = [[self.tableView indexPathForRowAtPoint:[recognizer locationOfTouch:0 inView:self.tableView]] row];
    NSUInteger row2 = [[self.tableView indexPathForRowAtPoint:[recognizer locationOfTouch:1 inView:self.tableView]] row];
    
    BOOL rowsAreAdjacent = (row1 == row2 + 1) || (row2 == row1 + 1);
    if (rowsAreAdjacent) {
        [self mergeRowNumber:row1 withRowNumber:row2];
    }
}

- (void)mergeRowNumber:(NSUInteger)row1 withRowNumber:(NSUInteger)row2
{
    NSLog(@"merging rows");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phrases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenizingCell"];
	
	cell.textLabel.text = [self.phrases objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)cancelPressed:(id)sender {
    [self.delegate tokenizingViewControllerDidCancel];
}

- (IBAction)donePressed:(id)sender {
    [self.delegate tokenizingViewControllerDidYieldPhrases:self.phrases];
}
@end
