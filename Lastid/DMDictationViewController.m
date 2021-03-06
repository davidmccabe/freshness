//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "DMDictationViewController.h"
#import "DMTokenizingViewController.h"

@implementation DMDictationViewController
@synthesize entryView;

- (void)viewWillAppear:(BOOL)animated
{
    self.entryView.layer.borderWidth = 1.0;
    self.entryView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [self.entryView becomeFirstResponder];
}

// Finish editing when the "Return" key on the keyboard is struck.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView != self.entryView) return YES;

    if ([text isEqualToString:@"\n"]) {
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
