//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMTokenizingViewController.h"
#import "NSMutableArray+PhraseArray.h"
#import "DMTextFieldCell.h"
#import "DMFood.h"

@interface DMTokenizingViewController ()
@property (strong, nonatomic) NSMutableArray *phrases;
@end

@implementation DMTokenizingViewController

@synthesize phrases;

- (void)setStringToBeTokenized:(NSString *)theString
{
    self.phrases = [NSMutableArray phraseArrayFromString:theString];
}

- (void)viewDidLoad
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleJoinGesture:)];
    recognizer.minimumPressDuration = 0.1;
    recognizer.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // self.navigationController has already been set to nil here.
    // We can't do this in viewWillDisappear without getting an ugly animation.
    UINavigationController *theNavigationController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    [theNavigationController setToolbarHidden:YES animated:animated];
}

# pragma mark ACTIONS

- (IBAction)addPressed:(id)sender {
    NSUInteger row = [self.phrases count];
    [self.phrases addObject:@""];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[(DMTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath] textField] becomeFirstResponder];
}

- (IBAction)donePressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    for (NSString *phrase in self.phrases) {
        [DMFood enterFoodWithName:phrase];
    }
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
}


# pragma mark ROW-MERGING GESTURE

- (void)handleJoinGesture:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateEnded) return;
    if (recognizer.numberOfTouches != 2) return;
    
    NSUInteger a = [[self.tableView indexPathForRowAtPoint:[recognizer locationOfTouch:0 inView:self.tableView]] row];
    NSUInteger b = [[self.tableView indexPathForRowAtPoint:[recognizer locationOfTouch:1 inView:self.tableView]] row];
    
    NSUInteger row1 = MIN(a,b);
    NSUInteger row2 = MAX(a,b);
    
    BOOL rowsAreAdjacent = (row1 == row2 - 1);
    if (rowsAreAdjacent) {
        [self mergeFirstRowNumber:row1 withSecondRowNumber:row2];
    }
}

- (void)mergeFirstRowNumber:(NSUInteger)row1 withSecondRowNumber:(NSUInteger)row2
{    
    [self.phrases mergePhraseAtIndex:row1 withPhraseAtIndex:row2];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self performSelector:@selector(updateRowTags) withObject:nil afterDelay:0.0];
}


#pragma mark TABLE VIEW DRECK

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phrases.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.phrases removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performSelector:@selector(updateRowTags) withObject:nil afterDelay:0.0];
    }   
}


#pragma mark EDITABLE TEXT CELLS

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenizingCell"];
	
	cell.textField.text = [self.phrases objectAtIndex:indexPath.row];
    cell.textField.tag = indexPath.row;
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.phrases replaceObjectAtIndex:textField.tag withObject:newString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    [textField resignFirstResponder];
    return YES;
}

- (void)updateRowTags {
    NSArray *visibleCells = [self.tableView visibleCells];  
    for (DMTextFieldCell *cell in visibleCells) {
        cell.textField.tag = [[self.tableView indexPathForCell:cell] row];
    }
}

@end
