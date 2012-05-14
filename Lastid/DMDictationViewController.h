//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>
#import "DMLookupViewController.h"
#import "DMTokenizingViewController.h"

@interface DMDictationViewController : UIViewController <UITextViewDelegate, DMLookupViewControllerDelegate, DMTokenizingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lookupButton;
@property (weak, nonatomic) IBOutlet UITextView *entryView;
@end
