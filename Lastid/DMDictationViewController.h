//
//  DMFirstViewController.h
//  Lastid
//
//  Created by David McCabe on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMDictationViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *entryView;

@end
