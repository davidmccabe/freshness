//  Copyright (c) 2012 David McCabe. All rights reserved.

#import "DMTokenizingViewController.h"
#import "DMTextFieldCell.h"
#import "DMFood.h"
#import "DMFoodList.h"

@interface DMTokenizingViewController ()
@property (strong, nonatomic) DMFoodList *foodNames;
@property (weak, nonatomic) UITextField *textFieldBeingEdited;
@property (copy, nonatomic) NSIndexPath *indexPathOfNewRow;
@end

@implementation DMTokenizingViewController

@synthesize foodNames;
@synthesize textFieldBeingEdited;
@synthesize indexPathOfNewRow;

- (void)setStringToBeTokenized:(NSString *)theString
{
    self.foodNames = [DMFoodList foodListFromString:theString];
}

- (void)viewDidLoad
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self action:@selector(joinPhrasesGestureWasRecognized:)];
    recognizer.minimumPressDuration = 0.1;
    recognizer.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Hide the toolbar.
    // self.navigationController has already been set to nil here.
    // We can't do this in viewWillDisappear without getting an ugly animation.
    id theNavigationController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [theNavigationController setToolbarHidden:YES animated:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

# pragma mark ACTIONS

- (IBAction)donePressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.foodNames commit];
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
}

- (IBAction)addPressed:(id)sender {
    [self.foodNames addObject:@""];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.foodNames count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // If the table is small enough to fit on screen, the newly-created row will
    // already have a visible cell now, so it should become the first responder immediately.
    // However, if we need to scroll to reveal the new row, the cell for that row will not exist
    // until the row has become visible, so we must wait before we send it becomeFirstResponder.
    id newCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (newCell) {
        [[newCell textField] becomeFirstResponder];
    }
    else {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        self.indexPathOfNewRow = indexPath; // Dealt with in scrollViewDidEndScrollingAnimation:.
    }
}

// See note at addPressed:.
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.indexPathOfNewRow) {
        id cell = [self.tableView cellForRowAtIndexPath:self.indexPathOfNewRow];
        [[cell textField] becomeFirstResponder];
        self.indexPathOfNewRow = nil;
    }
}


# pragma mark ROW-MERGING GESTURE

- (void)joinPhrasesGestureWasRecognized:(UIGestureRecognizer *)recognizer
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
    [self.foodNames mergeNameAtIndex:row1 withNameAtIndex:row2];
    
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
    return self.foodNames.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.foodNames removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performSelector:@selector(updateRowTags) withObject:nil afterDelay:0.0];
    }   
}


#pragma mark EDITABLE TEXT CELLS

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenizingCell"];
	
	cell.textField.text = [self.foodNames objectAtIndex:indexPath.row];
    cell.textField.tag = indexPath.row;
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.foodNames replaceObjectAtIndex:textField.tag withObject:newString];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = nil;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    CGRect keyboardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];    
    CGFloat insetHeight = keyboardFrame.size.height - self.navigationController.navigationBar.frame.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, insetHeight, 0);    

    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    
    if (self.textFieldBeingEdited) {
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:self.textFieldBeingEdited.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:theIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    double duration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    } completion:^(BOOL finished){}];
}

- (void)updateRowTags
{
    NSArray *visibleCells = [self.tableView visibleCells];  
    for (DMTextFieldCell *cell in visibleCells) {
        cell.textField.tag = [[self.tableView indexPathForCell:cell] row];
    }
}

@end
