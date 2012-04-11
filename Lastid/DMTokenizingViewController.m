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
