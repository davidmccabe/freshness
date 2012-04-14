//
//  DMFirstViewController.h
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLookupViewController.h"
#import "DMTokenizingViewController.h"

@interface DMDictationViewController : UIViewController <UITextViewDelegate, DMLookupViewControllerDelegate, DMTokenizingViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lookupButton;
@property (weak, nonatomic) IBOutlet UITextView *entryView;
@end
