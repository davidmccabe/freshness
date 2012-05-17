//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "DMDictationViewController.h"
#import "DMFood.h"
#import "NSString+Utilities.h"
#import "DMTokenizingViewController.h"

@interface DMDictationViewController ()
@end

@implementation DMDictationViewController
@synthesize entryView;

- (void)viewDidUnload
{
    [self setEntryView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    self.entryView.layer.borderWidth = 1.0;
    self.entryView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [self.entryView becomeFirstResponder];
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
        if (![textView.text isOnlyDelimiters])
            [self performSegueWithIdentifier:@"ShowReviewSegue" sender:self];
        return NO;
    } else {
        return YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setStringToBeTokenized:self.entryView.text];
}

@end
