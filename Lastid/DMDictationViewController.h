//  Copyright (c) 2012 David McCabe. All rights reserved.

#import <UIKit/UIKit.h>
#import "DMLookupViewController.h"

@interface DMDictationViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *entryView;
@end
