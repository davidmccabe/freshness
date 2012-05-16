//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>
#import "DMLookupViewController.h"
#import "DMTokenizingViewController.h"

@interface DMDictationViewController : UIViewController <UITextViewDelegate, DMTokenizingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *entryView;
@end
