//
//  DMDismissReviewSegue.m
//  Lastid
//
//  Created by David McCabe on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DMDismissReviewSegue.h"
#import "DMDictationViewController.h"

@implementation DMDismissReviewSegue

- (void)perform
{
    UIView *destView = [self.destinationViewController view];
    UIView *sourceView = [[self.sourceViewController navigationController] view];
    
    sourceView.layer.borderColor = [UIColor grayColor].CGColor;
    sourceView.layer.borderWidth = 1.0f;
    sourceView.layer.shadowOpacity = 0.5f;
    sourceView.layer.shadowRadius = 10.0f;
    
    [sourceView.superview insertSubview:destView belowSubview:sourceView];

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            sourceView.transform = CGAffineTransformMakeScale(0.2,0.2);
        }
        completion:^(BOOL finished) {
            [self performStepTwo];
        }
     ];
}

- (void)performStepTwo
{
    UIView *destView = [self.destinationViewController view];
    UIView *sourceView = [[self.sourceViewController navigationController] view];
    
    UIBarButtonItem *button = [self.destinationViewController lookupButton];
    button.tintColor = [UIColor redColor];
    
    [UIView animateWithDuration:0.6
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            sourceView.transform = CGAffineTransformMakeScale(0.1,0.1);
            sourceView.center = CGPointMake(285,55);
            sourceView.alpha = 0.5;
        }
        completion:^(BOOL finished) {
            button.tintColor = nil;
            
            [destView removeFromSuperview];
            [self.sourceViewController dismissViewControllerAnimated:NO completion:nil];
        }
     ];
}

@end
