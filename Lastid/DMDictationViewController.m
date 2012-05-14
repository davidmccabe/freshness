//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "DMDictationViewController.h"
#import "Food.h"
#import "NSString+Utilities.h"

@protocol DMDelegator <NSObject>
- (void)setDelegate:(id)theDelegate;
@end

@interface DMDictationViewController ()
- (void)entryDidFinish;
@property (copy, nonatomic) NSString *input;
@end

@implementation DMDictationViewController
@synthesize lookupButton;
@synthesize entryView;
@synthesize input;

- (void)viewDidUnload
{
    [self setEntryView:nil];
    [self setLookupButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Finish editing when the "Return" key on the keyboard is struck.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView != self.entryView) return YES;

    if ([text isEqualToString:@"\n"]) {
        // The return key is unavoidably enabled when any text is entered, even whitespace, but we ignore whitespace.
        if (![textView.text isOnlyDelimiters]) [self entryDidFinish];
        return NO;
    } else {
        return YES;
    }
}

- (void)entryDidFinish {
    self.input = self.entryView.text;
    self.entryView.text = @"";
    [self performSegueWithIdentifier:@"ShowReviewSegue" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    self.entryView.layer.borderWidth = 1.0;
    self.entryView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    static BOOL firstTime = TRUE;
    if(firstTime) [self.entryView becomeFirstResponder];
    firstTime = FALSE;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [(id <DMDelegator>)[segue.destinationViewController visibleViewController] setDelegate:self];
}

- (void)lookupViewControllerDidFinish:(DMLookupViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *) stringToBeTokenized
{
    return self.input;
}

- (void) tokenizingViewControllerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) tokenizingViewControllerDidYieldPhrases:(NSArray *)phrases
{
    for (NSString *phrase in phrases) {
        [Food enterFoodWithName:phrase];
    }
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
}

@end
