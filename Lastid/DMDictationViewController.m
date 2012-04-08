//
//  DMFirstViewController.m
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMDictationViewController.h"
#import "Food.h"

@interface DMDictationViewController ()
- (void)entryDidFinish;
@end

@implementation DMDictationViewController
@synthesize entryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setEntryView:nil];
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
        [self entryDidFinish];
        return NO;
    } else {
        return YES;
    }
}

- (void)entryDidFinish {
    [self.entryView resignFirstResponder];
    NSArray *tokens = [self.entryView.text componentsSeparatedByString:@" "];
    for (NSString *token in tokens) {
        [Food enterFoodWithName:token];
    }
    [[NSManagedObjectContext MR_defaultContext] save:NULL];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.entryView becomeFirstResponder];
}

@end
